return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- Colorscheme
  use({
    "rose-pine/neovim",
    as = "rose-pine",
    tag = "v1.*",
    config = function()
      vim.cmd("colorscheme rose-pine")
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
  use("williamboman/nvim-lsp-installer")
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("user.plugins.null-ls")
    end,
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
    "ur4ltz/surround.nvim",
    config = function()
      require("surround").setup({
        mappings_style = "sandwich",
      })
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
