-- Additional Plugins
lvim.plugins = {
  "mfussenegger/nvim-jdtls",
  "rcarriga/nvim-dap-ui",
  "tpope/vim-fugitive",
  {
    "saecki/crates.nvim",
    version = "v0.3.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          border = "rounded",
        },
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    }
  },
  {
    "simrat39/rust-tools.nvim",
    config = function()
      require("user.rust_tools").config()
      -- local rt = require("rust-tools")

      -- rt.setup({
      --   server = {
      --     on_attach = function(_, bufnr)
      --       -- Hover actions
      --       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      --       -- Code action groups
      --       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      --     end,
      --   },
      -- })
    end
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").init()
      require 'nvim-treesitter.configs'.setup {
        autotag = {
          enable = true,
        }
      }
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
    }
  },
  {
    "olexsmir/gopher.nvim",
    config = function()
      require("gopher").setup {
        commands = {
          go = "go",
          gomodifytags = "gomodifytags",
          gotests = "gotests",
          impl = "impl",
          iferr = "iferr",
        },
      }
    end,
    ft = { "go", "gomod" },
    event = { "BufRead", "BufNew" },
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
    ft = { "go", "gomod" },
    event = { "BufRead", "BufNew" },
  },
  {
    "ray-x/web-tools.nvim",
  },
  {
    "NvChad/nvim-colorizer.lua"
  },
  {
    "Xuyuanp/scrollbar.nvim"
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup()
    end
  }
}
