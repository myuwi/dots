return {
  -- Colorscheme
  {
    "rose-pine/neovim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("rose-pine").setup({
        disable_float_background = true,
        highlight_groups = {
          -- NormalFloat = { fg = "text", bg = "surface" },
          FloatBorder = { fg = "highlight_high", bg = "surface" },
        },
      })

      vim.cmd.colorscheme("rose-pine")
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = "virtualtext",
        virtualtext = "■", -- the virtual text block
      },
    },
  },

  -- LSP
  "neovim/nvim-lspconfig",
  -- "williamboman/nvim-lsp-installer"
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("user.plugins.null-ls")
    end,
  },

  "folke/neodev.nvim",

  {
    "Fymyte/rasi.vim",
    ft = "rasi",
  },

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-nvim-lsp",

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("user.plugins.treesitter")
    end,
  },
  "nvim-treesitter/playground",

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("user.plugins.luasnip")
    end,
  },
  "rafamadriz/friendly-snippets",

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    config = true,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- Which key
  {
    "folke/which-key.nvim",
    config = true,
  },

  "b0o/schemastore.nvim",

  "nvim-lua/plenary.nvim",

  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  {
    "kylechui/nvim-surround",
    config = true,
  },

  "famiu/bufdelete.nvim",

  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_auto_close = 0
    end,
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = true,
  },

  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    config = function()
      local peek = require("peek")

      vim.api.nvim_create_user_command("PeekOpen", function()
        if not peek.is_open() then
          peek.open()
        end
      end, {})
      vim.api.nvim_create_user_command("PeekClose", function()
        if peek.is_open() then
          peek.close()
        end
      end, {})
    end,
  },
}
