{
  inputs,
  pkgs,
  lib,
  user,
  ...
}:
let
  aliases = {
    vim = "nvim";
  };
in
{
  options.neovim = lib.mkEnableOption "neovim";
  config = {
    home.shellAliases = aliases;
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
        vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct
        vim.g.maplocalleader = " "

        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
          -- bootstrap lazy.nvim
          -- stylua: ignore
          vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
            lazypath })
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
                languages = {
                  "lua",
                },
              },
            },
            {
              "wuz/lackluster.nvim",
              dev = true,
              lazy = false,
              priority = 1000,
              opts = function()
                local lackluster = require("lackluster")
                local color = lackluster.color -- blue, green, red, orange, black, lack, luster, gray1-9
                return {
                  tweak_syntax = {
                    comment = color.gray6,
                  },
                }
              end,
            },
            { import = "cantrip.plugins.extras.test" },
            -- -- Language specific plugins and configs
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
            -- -- extra plugins
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
            -- import/override with your plugins
            { import = "plugins" },
          },
          defaults = {
            version = false, -- always use the latest git commit
          },
          checker = { enabled = true }, -- automatically check for plugin updates
          performance = {
            cache = { enabled = true },
            rtp = {
              -- disable some rtp plugins
              disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
        })
      '';

      "nvim/lua/plugins.lua".text = ''
        return {
          { "meznaric/key-analyzer.nvim", opts = {} },
          -- { "imsnif/kdl.vim", config = function() end },
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
            fmta(
              [[
          type <ComponentName>Props = {};
          const <ComponentName> = (<Props>: <ComponentName>Props) =>> {
            return <Return>
          }

          export default <ComponentName>;
          ]],
              {
                ComponentName = i(1, "ComponentName", { desc = "Component Name" }),
                Props = i(2, "{}", { desc = "Component props" }),
                Return = i(3, "<div />", { desc = "The component return" }),
              },
              {
                repeat_duplicates = true,
              }
            )
          ),
        }
      '';

      "nvim/snippets/typescriptreact.json".text = ''
        {
          "storybook": {
            "prefix": "storybook",
            "body": [
              "import type { Meta, StoryObj } from \"@storybook/react\";",
              "",
              "import ${"1:Component"} from \"${"2:."}\";",
              "",
              "const meta: Meta<typeof ''${1}> = {",
              "  title: \"${"3:Component"}\",",
              "  component: ''${1},",
              "  argTypes: {},",
              "};",
              "",
              "export default meta;",
              "type Story = StoryObj<typeof ''${1}>;",
              "",
              "export const Primary: Story = {",
              "  args: { },",
              "};"
            ]
          }
        }
      '';

      "nvim/snippets/swift.json".text = ''
        {
          "public access control": {
            "prefix": "pub",
            "body": ["public $0"],
            "description": "public access control"
          },
          "private access control": {
            "prefix": "priv",
            "body": ["private $0"],
            "description": "private access control"
          },
          "if statement": {
            "prefix": "if",
            "body": ["if $1 {", "\t$2", "}$0"],
            "description": "if statement"
          },
          "if let": {
            "prefix": "ifl",
            "body": ["if let $1 = ${"2:$1"} {", "\t$3", "}$0"],
            "description": "if let"
          },
          "if case let": {
            "prefix": "ifcl",
            "body": ["if case let $1 = ${"2:$1"} {", "\t$3", "}$0"],
            "description": "if case let"
          },
          "function declaration": {
            "prefix": "func",
            "body": ["func $1($2) $3{", "\t$0", "}"],
            "description": "function declaration"
          },
          "async function declaration": {
            "prefix": "funca",
            "body": ["func $1($2) async $3{", "\t$0", "}"],
            "description": "async function declaration"
          },
          "guard": {
            "prefix": "guard",
            "body": ["guard $1 else {", "\t$2", "}$0"],
            "description": "guard statement"
          },
          "guard let": {
            "prefix": "guardl",
            "body": ["guard let $1 else {", "\t$2", "}$0"],
            "description": "guard let"
          },
          "main entry point": {
            "prefix": "main",
            "body": [
              "@main public struct ${"1:App"} {",
              "\tpublic static func main() {",
              "\t\t$2",
              "\t}",
              "}$0"
            ],
            "description": "@main entry point"
          }
        }
      '';

      "nvim/snippets/package.json".text = ''
        {"name":"my-snippets","contributes":{"snippets":[{"language":["typescriptreact"],"path":"./typescriptreact.json"},{"language":["swift"],"path":"./swift.json"}]},"description":"This package.json has been generated by nvim-scissors."}
      '';
    };
  };
}
