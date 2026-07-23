# Program bundles — shared include lists so hosts don't repeat 20+ aspects.
#
#   work.cli     — headless/server toolset (tower)
#   work.desktop — cli + GUI/desktop programs (spellbook, grimoire)
#
# Adding a program to every machine: add it to `cli`.
# Adding a desktop-only program: add it to `desktop`.
{ work, ... }: {
  work.cli.includes = with work; [
    # keep-sorted start
    bat
    bin
    direnv
    git
    mcfly
    neovim
    nixtools
    node
    optout
    rust
    starship
    tmux
    zoxide
    zsh
    # keep-sorted end
  ];

  work.desktop.includes = [
    work.cli
  ]
  ++ (with work; [
    # keep-sorted start
    browser
    email
    ghostty
    jj
    lua
    ruby
    ssh
    tui
    wezterm
    # keep-sorted end
  ]);
}
