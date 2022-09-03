-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
--   pattern = "lua/user/plugins/init.lua",
--   desc = "Reload neovim when neovim plugins file is saved",
--   callback = function()
--     vim.cmd("so <afile> | PackerSync")
--   end,
-- })

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- Colorscheme
  use({
    "rose-pine/neovim",
    as = "rose-pine",
    tag = "v1.*",
    config = function()
      require("rose-pine").setup({
        highlight_groups = {
          -- NormalFloat = { fg = "text", bg = "surface" },
          FloatBorder = { fg = "highlight_high", bg = "surface" },
        },
      })

      vim.cmd("colorscheme rose-pine")
    end,
  })

  use({
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup(nil, {
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
      })
    end,
  })

  -- UI
  use({
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require("user.plugins.nvim-tree")
    end,
  })

  use({
    "akinsho/bufferline.nvim",
    tag = "*",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("user.plugins.bufferline")
    end,
  })

  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("user.plugins.lualine")
    end,
  })

  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("user.plugins.telescope")
    end,
  })

  -- LSP
  use("neovim/nvim-lspconfig")
  -- use("williamboman/nvim-lsp-installer")
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("user.plugins.null-ls")
    end,
  })

  use("folke/lua-dev.nvim")

  use({
    "Fymyte/rasi.vim",
    ft = "rasi",
  })

  -- Completion
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("saadparwaiz1/cmp_luasnip")
  use("hrsh7th/cmp-nvim-lsp")

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("user.plugins.treesitter")
    end,
  })

  -- snippets
  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("user.plugins.luasnip")
    end,
  })
  use("rafamadriz/friendly-snippets")

  -- Autopairs
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  })

  -- Comment
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })

  -- Which key
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  })

  use("b0o/schemastore.nvim")

  use("nvim-lua/plenary.nvim")

  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  })

  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  })

  use("famiu/bufdelete.nvim")

  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end,
  })
end)
