#!/usr/bin/env python3
"""
tmux-hint: interactive which-key style hint popup for tmux.

Invoked by tmux-hint.sh inside a display-popup. Reads the which-key YAML,
renders a hint window, waits for a keypress, navigates the tree, and
eventually writes a tmux command to execute back to the parent shell.
"""

import os
import sys
import tty
import termios
import struct
import fcntl
import json
import re

# ── YAML parser (stdlib only, no pyyaml dependency) ───────────────────────────

def parse_yaml_items(path):
    """
    Minimal YAML parser for the which-key config format.
    Returns a list of item dicts. Supports: name, key, command, macro, menu,
    separator, transient. Handles quoted strings and nested menus.
    """
    with open(path) as f:
        text = f.read()

    # Strip comments
    lines = []
    for line in text.split('\n'):
        stripped = line.rstrip()
        # Remove inline comments (but not inside quoted strings)
        result = ''
        in_q = False
        q_char = None
        i = 0
        while i < len(stripped):
            c = stripped[i]
            if in_q:
                result += c
                if c == q_char:
                    in_q = False
            elif c in ('"', "'"):
                in_q = True
                q_char = c
                result += c
            elif c == '#':
                break
            else:
                result += c
            i += 1
        lines.append(result)

    # Parse into token stream: (indent, key, value)
    def unquote(s):
        s = s.strip()
        if (s.startswith('"') and s.endswith('"')) or \
           (s.startswith("'") and s.endswith("'")):
            return s[1:-1]
        return s

    def parse_block(lines, start, base_indent):
        """Parse a block of items starting at `start` with expected indent >= base_indent."""
        items = []
        i = start
        while i < len(lines):
            line = lines[i]
            if not line.strip():
                i += 1
                continue
            indent = len(line) - len(line.lstrip())
            if indent < base_indent:
                break
            stripped = line.strip()
            if stripped.startswith('- '):
                # New item
                item = {}
                item_indent = indent + 2  # content indent inside the item
                # Parse the first key:value on the same line as '-'
                rest = stripped[2:]
                if ':' in rest:
                    k, _, v = rest.partition(':')
                    k = k.strip()
                    v = v.strip()
                    if k == 'separator':
                        item['separator'] = True
                    elif v:
                        item[k] = unquote(v)
                    else:
                        # block value follows
                        item[k] = None
                i += 1
                # Parse continuation lines at item_indent
                while i < len(lines):
                    line2 = lines[i]
                    if not line2.strip():
                        i += 1
                        continue
                    indent2 = len(line2) - len(line2.lstrip())
                    if indent2 < item_indent:
                        break
                    stripped2 = line2.strip()
                    if stripped2.startswith('- '):
                        # sub-list (menu items)
                        sub_items, i = parse_block(lines, i, indent2)
                        item['menu'] = sub_items
                    elif ':' in stripped2:
                        k2, _, v2 = stripped2.partition(':')
                        k2 = k2.strip()
                        v2 = v2.strip()
                        if v2:
                            item[k2] = unquote(v2)
                        # else: we'll pick it up as a sub-block next iteration
                        i += 1
                    else:
                        i += 1
                items.append(item)
            elif stripped.startswith('-'):
                # bare '-' separator
                items.append({'separator': True})
                i += 1
            else:
                i += 1
        return items, i

    # Find the 'items:' section
    items_start = None
    for idx, line in enumerate(lines):
        if re.match(r'^items\s*:', line):
            items_start = idx + 1
            break

    if items_start is None:
        return []

    items, _ = parse_block(lines, items_start, 2)
    return items


def find_macros(path):
    """Extract macro name→commands mapping from YAML."""
    macros = {}
    with open(path) as f:
        text = f.read()
    # Simple regex: find macro blocks
    for m in re.finditer(r'- name: ([^\n]+)\n\s+commands:\n((?:\s+- [^\n]+\n?)+)', text):
        name = m.group(1).strip().strip('"\'')
        cmds_text = m.group(2)
        cmds = [re.sub(r'^\s+- ', '', l).strip().strip('"\'')
                for l in cmds_text.split('\n') if l.strip().startswith('- ')]
        macros[name] = cmds
    return macros


# ── Terminal helpers ──────────────────────────────────────────────────────────

def get_terminal_size():
    try:
        s = struct.pack('HHHH', 0, 0, 0, 0)
        result = fcntl.ioctl(sys.stdout.fileno(), termios.TIOCGWINSZ, s)
        rows, cols, _, _ = struct.unpack('HHHH', result)
        return rows, cols
    except Exception:
        return 24, 80


def read_key():
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        ch = os.read(fd, 1)
        if ch == b'\x1b':
            # Might be escape sequence — try to read more
            fcntl.fcntl(fd, fcntl.F_SETFL, os.O_NONBLOCK)
            try:
                rest = os.read(fd, 8)
                ch += rest
            except BlockingIOError:
                pass
            finally:
                fcntl.fcntl(fd, fcntl.F_SETFL, 0)
        return ch
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)


# ── Rendering ─────────────────────────────────────────────────────────────────

# Lackluster palette (matches ghostty/nvim theme)
C_RESET  = '\x1b[0m'
C_BG     = '\x1b[48;2;10;10;10m'       # #0a0a0a
C_KEY    = '\x1b[38;2;119;153;120m'    # #789978 green
C_GROUP  = '\x1b[38;2;119;136;170m'    # #7788aa blue
C_DESC   = '\x1b[38;2;222;238;237m'    # #deeeed fg
C_DIM    = '\x1b[38;2;68;68;68m'       # #444444
C_TITLE  = '\x1b[38;2;255;170;136m'    # #ffaa88 orange
C_BORDER = '\x1b[38;2;112;128;144m'    # #708090 slate
C_BOLD   = '\x1b[1m'


def render_hint(items, path, cols):
    """
    Render the hint panel. Returns a list of lines.
    path: list of key strings showing navigation breadcrumb.
    """
    lines = []

    # Title bar
    breadcrumb = ' > '.join(path) if path else 'tmux'
    title = f' {C_TITLE}{C_BOLD}prefix{C_RESET}{C_BORDER} › {C_TITLE}{breadcrumb}{C_RESET} '
    lines.append(title)
    lines.append(f'{C_DIM}' + '─' * cols + C_RESET)

    # Items — lay out in two columns
    visible = [it for it in items if not it.get('separator')]
    col_width = (cols - 2) // 2

    rows_needed = (len(visible) + 1) // 2
    for row in range(rows_needed):
        left = visible[row] if row < len(visible) else None
        right = visible[row + rows_needed] if (row + rows_needed) < len(visible) else None

        def fmt_item(item, width):
            if item is None:
                return ' ' * width
            key = item.get('key', '')
            name = item.get('name', '')
            is_group = 'menu' in item

            # Normalize display key
            display_key = key
            if key == 'space':
                display_key = 'SPC'
            elif key == 'tab':
                display_key = 'TAB'
            elif key == '`':
                display_key = '`'

            key_color = C_GROUP if is_group else C_KEY
            key_str = f'{key_color}{C_BOLD}{display_key:<3}{C_RESET}'
            desc_color = C_GROUP if is_group else C_DESC
            desc = f'{desc_color}{name}{C_RESET}'

            # Measure visible length (strip ANSI)
            ansi_re = re.compile(r'\x1b\[[0-9;]*m')
            key_vis = len(ansi_re.sub('', key_str))
            desc_vis = len(ansi_re.sub('', desc))
            total_vis = key_vis + 2 + desc_vis
            pad = max(0, width - total_vis)
            return f'{key_str}  {desc}' + ' ' * pad

        left_str = fmt_item(left, col_width)
        right_str = fmt_item(right, col_width) if right else ''
        lines.append(f' {left_str}{right_str}')

    lines.append(f'{C_DIM}' + '─' * cols + C_RESET)
    lines.append(f'{C_DIM} <esc> cancel   <?> all keys{C_RESET}')
    return lines


def clear_screen():
    sys.stdout.write('\x1b[2J\x1b[H')
    sys.stdout.flush()


# ── Main loop ─────────────────────────────────────────────────────────────────

def main():
    config_path = os.environ.get(
        'TMUX_HINT_CONFIG',
        os.path.expanduser('~/.config/tmux/tmux-hint/which-key.yaml')
    )
    socket_path = os.environ.get('TMUX')
    out_file = os.environ.get('TMUX_HINT_OUT')

    if not os.path.exists(config_path):
        sys.stderr.write(f'tmux-hint: config not found: {config_path}\n')
        sys.exit(1)

    all_items = parse_yaml_items(config_path)
    macros = find_macros(config_path)

    current_items = all_items
    path = []

    while True:
        rows, cols = get_terminal_size()
        cols = min(cols, 120)
        clear_screen()
        hint_lines = render_hint(current_items, path, cols)
        print('\n'.join(hint_lines), flush=True)

        key_bytes = read_key()

        # Escape → cancel
        if key_bytes in (b'\x1b', b'q'):
            if out_file:
                open(out_file, 'w').close()
            sys.exit(0)

        # Decode key
        if key_bytes == b' ':
            key = 'space'
        elif key_bytes == b'\t':
            key = 'tab'
        elif key_bytes == b'\r' or key_bytes == b'\n':
            key = 'enter'
        else:
            try:
                key = key_bytes.decode('utf-8')
            except Exception:
                continue

        # Find matching item
        match = None
        for item in current_items:
            if item.get('separator'):
                continue
            if item.get('key') == key:
                match = item
                break

        if match is None:
            # Unknown key — flash and retry
            continue

        if 'menu' in match:
            # Navigate into submenu
            path.append(match.get('name', key))
            current_items = match['menu']
            continue

        # Leaf — build command and write it out
        cmd = None
        if 'command' in match:
            cmd = match['command']
        elif 'macro' in match:
            macro_name = match['macro']
            cmds = macros.get(macro_name, [])
            cmd = ' ; '.join(cmds)

        if cmd and out_file:
            with open(out_file, 'w') as f:
                f.write(cmd)
        sys.exit(0)


if __name__ == '__main__':
    main()
