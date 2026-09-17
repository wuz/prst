return {
  { "meznaric/key-analyzer.nvim", opts = function() return {} end },
  {
    -- Cmd key mappings received as CSI u sequences via:
    -- Ghostty (text:\x1b[...~) → tmux user-keys (re-emits as \x1b[...u) → neovim <D-*>
    "ibhagwan/fzf-lua",
    optional = true,
    keys = {
      { "<D-p>",   "<cmd>FzfLua files<cr>",            desc = "Find file (Cmd+P)" },
      { "<D-S-f>", "<cmd>FzfLua live_grep_native<cr>", desc = "Search in project (Cmd+Shift+F)" },
      { "<D-S-p>", "<cmd>FzfLua commands<cr>",         desc = "Command palette (Cmd+Shift+P)" },
    },
  },
  {
    "aserowy/tmux.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
      copy_sync = {
        enable = true,
        sync_clipboard = true,
        sync_registers = true,
      },
      navigation = {
        -- C-h/j/k/l: conflicts with mini-move (text movement) so wire manually below
        enable_default_keybindings = false,
        cycle_navigation = true,
      },
      resize = {
        -- Alt-h/j/k/l: conflicts with mini-tabline buffer prev/next (<M-h>/<M-l>)
        -- Use Alt+Shift (M-H/J/K/L) for pane resize instead
        enable_default_keybindings = false,
      },
      })
    end,
    keys = {
      -- Navigation: C-h/j/k/l — smart tmux/nvim split switching
      { "<C-h>", function() require("tmux").move_left() end,  desc = "tmux/nvim left" },
      { "<C-j>", function() require("tmux").move_bottom() end, desc = "tmux/nvim down" },
      { "<C-k>", function() require("tmux").move_top() end,   desc = "tmux/nvim up" },
      { "<C-l>", function() require("tmux").move_right() end, desc = "tmux/nvim right" },
      -- Resize: M-H/J/K/L (shift+alt) — no conflict with M-h/M-l (buffer nav)
      { "<M-H>", function() require("tmux").resize_left() end,  desc = "resize pane left" },
      { "<M-J>", function() require("tmux").resize_bottom() end, desc = "resize pane down" },
      { "<M-K>", function() require("tmux").resize_top() end,   desc = "resize pane up" },
      { "<M-L>", function() require("tmux").resize_right() end, desc = "resize pane right" },
    },
  },
}
