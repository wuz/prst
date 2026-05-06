{ inputs, ... }:
{
  prst.neovim = {
    homeManager =
      { pkgs, ... }:
      {
        home.shellAliases.vim = "nvim";

        programs.neovim = {
          package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
          enable = true;
          defaultEditor = true;
          vimAlias = true;
          withNodeJs = true;
          withPython3 = true;
          withRuby = true;
        };

        xdg.configFile = {
          "nvim/init.lua".text = ''
            vim.g.mapleader = " "
            vim.g.maplocalleader = " "

            local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
            if not vim.loop.fs_stat(lazypath) then
              vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
            end
            vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

            require("lazy").setup({
              dev = {
                path = "~/dev/github/wuz",
                patterns = { "wuz", "cantrip.nvim", "lackluster.nvim" },
                fallback = false,
              },
              spec = {
                {
                  "wuz/cantrip.nvim",
                  dev = true,
                  import = "cantrip.plugins",
                  opts = {
                    translucent = false,
                    theme = "lackluster-dark",
                    languages = { "lua" },
                  },
                },
                {
                  "wuz/lackluster.nvim",
                  dev = true,
                  lazy = false,
                  priority = 1000,
                  opts = function()
                    local lackluster = require("lackluster")
                    local color = lackluster.color
                    return {
                      tweak_syntax = { comment = color.gray6 },
                    }
                  end,
                },
                { import = "cantrip.plugins.extras.test" },
                { import = "cantrip.plugins.lsp.languages.lua" },
                { import = "cantrip.plugins.lsp.languages.javascript" },
                { import = "cantrip.plugins.lsp.languages.grit" },
                { import = "cantrip.plugins.lsp.languages.rust" },
                { import = "cantrip.plugins.lsp.languages.nix" },
                { import = "cantrip.plugins.lsp.languages.markdown" },
                { import = "cantrip.plugins.lsp.languages.python" },
                { import = "cantrip.plugins.lsp.languages.css" },
                { import = "cantrip.plugins.lsp.languages.swift" },
                { import = "cantrip.plugins.lsp.languages.react" },
                { import = "cantrip.plugins.lsp.languages.yaml" },
                { import = "cantrip.plugins.extras.oil" },
                { import = "cantrip.plugins.extras.terminal" },
                { import = "cantrip.plugins.extras.ai.opencode" },
                { import = "cantrip.plugins.extras.ai.99" },
                { import = "cantrip.plugins.extras.miniharp" },
                { import = "cantrip.plugins.extras.sessions" },
                { import = "cantrip.plugins.extras.tailwind" },
                { import = "cantrip.plugins.extras.nvim_highlight_colors" },
                { import = "cantrip.plugins.extras.git" },
                { import = "cantrip.plugins.extras.worktrees" },
                { import = "cantrip.plugins.ui.inclines.harpoon" },
                { import = "plugins" },
              },
              defaults = { version = false },
              checker = { enabled = true },
              performance = {
                cache = { enabled = true },
                rtp = {
                  disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
                },
              },
            })
          '';

          "nvim/lua/plugins.lua".text = ''
            return {
              { "meznaric/key-analyzer.nvim", opts = {} },
            }
          '';

          "nvim/lua/snippets/typescriptreact.lua".text = ''
            local ls = require("luasnip")
            local s = ls.snippet
            local i = ls.insert_node
            local fmta = require("luasnip.extras.fmt").fmta

            return {
              s(
                { trig = "RCC", name = "React Client Component", desc = "Scaffold for a React Client Component" },
                fmta([[
            type <ComponentName>Props = {};
            const <ComponentName> = (<Props>: <ComponentName>Props) =>> {
              return <Return>
            }

            export default <ComponentName>;
                ]], {
                  ComponentName = i(1, "ComponentName", { desc = "Component Name" }),
                  Props = i(2, "{}", { desc = "Component props" }),
                  Return = i(3, "<div />", { desc = "The component return" }),
                }, { repeat_duplicates = true })
              ),
            }
          '';

          "nvim/snippets/package.json".text = ''
            {"name":"my-snippets","contributes":{"snippets":[{"language":["typescriptreact"],"path":"./typescriptreact.json"},{"language":["swift"],"path":"./swift.json"}]},"description":"Generated by nvim-scissors."}
          '';
        };
      };
  };
}
