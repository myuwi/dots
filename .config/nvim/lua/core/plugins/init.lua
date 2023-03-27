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
          -- FloatBorder = { fg = "highlight_high", bg = "surface" },
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
