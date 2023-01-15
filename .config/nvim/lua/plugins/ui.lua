return {
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    opts = {
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        icons = {
          hint = "H",
          info = "I",
          warning = "W",
          error = "E",
        },
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 400,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "rose-pine/neovim",
      "famiu/bufdelete.nvim",
    },
    opts = function()
      local p = require("rose-pine.palette")

      return {
        highlights = {
          fill = {
            fg = p.text,
            bg = p.base,
          },
          background = {
            fg = p.highlight_high,
            bg = p.base,
          },
          buffer_visible = {
            fg = p.highlight_high,
            bg = p.base,
          },
          buffer_selected = {
            fg = p.text,
            bg = p.surface,
            bold = true,
          },
          close_button = {
            fg = p.highlight_high,
            bg = p.base,
          },
          close_button_visible = {
            fg = p.highlight_high,
            bg = p.base,
          },
          close_button_selected = {
            fg = p.text,
            bg = p.surface,
          },
          -- diagnostic = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- diagnostic_visible = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- diagnostic_selected = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	gui = 'bold,italic',
          -- },
          -- info = {
          -- 	fg = '<color-value-here>',
          -- 	guisp = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- info_visible = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- info_selected = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	gui = 'bold,italic',
          -- 	guisp = '<color-value-here>',
          -- },
          -- info_diagnostic = {
          -- 	fg = '<color-value-here>',
          -- 	guisp = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- info_diagnostic_visible = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- info_diagnostic_selected = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	gui = 'bold,italic',
          -- 	guisp = '<color-value-here>',
          -- },
          -- warning = {
          -- 	fg = '<color-value-here>',
          -- 	guisp = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- warning_visible = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- warning_selected = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	gui = 'bold,italic',
          -- 	guisp = '<color-value-here>',
          -- },
          -- warning_diagnostic = {
          -- 	fg = '<color-value-here>',
          -- 	guisp = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- warning_diagnostic_visible = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- warning_diagnostic_selected = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	gui = 'bold,italic',
          -- 	guisp = warning_diagnostic_fg,
          -- },
          -- error = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	guisp = '<color-value-here>',
          -- },
          -- error_visible = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- error_selected = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	gui = 'bold,italic',
          -- 	guisp = '<color-value-here>',
          -- },
          -- error_diagnostic = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	guisp = '<color-value-here>',
          -- },
          -- error_diagnostic_visible = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- error_diagnostic_selected = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- 	gui = 'bold,italic',
          -- 	guisp = '<color-value-here>',
          -- },
          modified = {
            fg = p.gold,
            bg = p.base,
          },
          modified_visible = {
            fg = p.gold,
            bg = p.base,
          },
          modified_selected = {
            fg = p.gold,
            bg = p.surface,
          },
          duplicate_selected = {
            fg = p.text,
            bg = p.surface,
            italic = false,
          },
          duplicate_visible = {
            fg = p.highlight_med,
            bg = p.base,
            italic = false,
          },
          duplicate = {
            fg = p.highlight_med,
            bg = p.base,
            italic = false,
          },
          -- separator_selected = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- separator_visible = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- separator = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          indicator_selected = {
            fg = p.surface,
            bg = p.surface,
          },
          pick_selected = {
            fg = p.love,
            bg = p.surface,
            bold = true,
            italic = true,
          },
          pick_visible = {
            fg = p.love,
            bg = p.base,
            bold = true,
            italic = true,
          },
          pick = {
            fg = p.love,
            bg = p.base,
            bold = true,
            italic = true,
          },
          -- tab = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
          -- tab_selected = {
          -- 	fg = tabline_sel_bg,
          -- 	bg = '<color-value-here>',
          -- },
          -- tab_close = {
          -- 	fg = '<color-value-here>',
          -- 	bg = '<color-value-here>',
          -- },
        },
        options = {
          show_close_icon = false,
          indicator = {
            style = "none",
          },
          separator_style = { "", "" },
          close_command = function(bufnum)
            require("bufdelete").bufdelete(bufnum, true)
          end,
          right_mouse_command = "",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "packer", "NVimTree" },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "nvim-tree", "toggleterm" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        file_ignore_patterns = {
          "^.git/",
          ".svelte%-kit/",
          ".netlify/",
          "node_modules",
          "target",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "-uu",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
        },
        live_grep = {
          hidden = true,
        },
      },
    },
  },
}
