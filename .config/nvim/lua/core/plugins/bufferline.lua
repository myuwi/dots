return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "rose-pine/neovim",
    "famiu/bufdelete.nvim",
  },
  lazy = false,
  keys = {
    { "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Cycle next buffer" },
    { "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Cycle previous buffer" },
    { "<C-A-j>", "<cmd>BufferLineMoveNext<CR>", desc = "Move current buffer forwards" },
    { "<C-A-k>", "<cmd>BufferLineMovePrev<CR>", desc = "Move current buffer backwards" },
    { "<Leader>bd", "<cmd>Bdelete<CR>", desc = "Delete current buffer" },
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
}
