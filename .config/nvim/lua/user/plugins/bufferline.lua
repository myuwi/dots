local p = require("rose-pine.palette")

require("bufferline").setup({
  highlights = {
    fill = {
      guifg = p.text,
      guibg = p.base,
    },
    background = {
      guifg = p.highlight_high,
      guibg = p.base,
    },
    buffer_visible = {
      guifg = p.highlight_high,
      guibg = p.base,
    },
    buffer_selected = {
      guifg = p.text,
      guibg = p.surface,
      gui = "bold",
    },
    close_button = {
      guifg = p.highlight_high,
      guibg = p.base,
    },
    close_button_visible = {
      guifg = p.highlight_high,
      guibg = p.base,
    },
    close_button_selected = {
      guifg = p.text,
      guibg = p.surface,
    },
    -- diagnostic = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- diagnostic_visible = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- diagnostic_selected = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	gui = 'bold,italic',
    -- },
    -- info = {
    -- 	guifg = '<color-value-here>',
    -- 	guisp = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- info_visible = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- info_selected = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	gui = 'bold,italic',
    -- 	guisp = '<color-value-here>',
    -- },
    -- info_diagnostic = {
    -- 	guifg = '<color-value-here>',
    -- 	guisp = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- info_diagnostic_visible = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- info_diagnostic_selected = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	gui = 'bold,italic',
    -- 	guisp = '<color-value-here>',
    -- },
    -- warning = {
    -- 	guifg = '<color-value-here>',
    -- 	guisp = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- warning_visible = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- warning_selected = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	gui = 'bold,italic',
    -- 	guisp = '<color-value-here>',
    -- },
    -- warning_diagnostic = {
    -- 	guifg = '<color-value-here>',
    -- 	guisp = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- warning_diagnostic_visible = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- warning_diagnostic_selected = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	gui = 'bold,italic',
    -- 	guisp = warning_diagnostic_fg,
    -- },
    -- error = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	guisp = '<color-value-here>',
    -- },
    -- error_visible = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- error_selected = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	gui = 'bold,italic',
    -- 	guisp = '<color-value-here>',
    -- },
    -- error_diagnostic = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	guisp = '<color-value-here>',
    -- },
    -- error_diagnostic_visible = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- error_diagnostic_selected = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- 	gui = 'bold,italic',
    -- 	guisp = '<color-value-here>',
    -- },
    modified = {
      guifg = p.gold,
      guibg = p.base,
    },
    modified_visible = {
      guifg = p.gold,
      guibg = p.base,
    },
    modified_selected = {
      guifg = p.gold,
      guibg = p.surface,
    },

    duplicate_selected = {
      guifg = p.text,
      guibg = p.surface,
      gui = "default",
    },
    duplicate_visible = {
      guifg = p.highlight_med,
      guibg = p.base,
      gui = "default",
    },
    duplicate = {
      guifg = p.highlight_med,
      guibg = p.base,
      gui = "default",
    },
    -- separator_selected = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- separator_visible = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- separator = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    indicator_selected = {
      guifg = p.surface,
      guibg = p.surface,
    },
    pick_selected = {
      guifg = p.love,
      guibg = p.surface,
      gui = "bold,italic",
    },
    pick_visible = {
      guifg = p.love,
      guibg = p.base,
      gui = "bold,italic",
    },
    pick = {
      guifg = p.love,
      guibg = p.base,
      gui = "bold,italic",
    },
    -- tab = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
    -- tab_selected = {
    -- 	guifg = tabline_sel_bg,
    -- 	guibg = '<color-value-here>',
    -- },
    -- tab_close = {
    -- 	guifg = '<color-value-here>',
    -- 	guibg = '<color-value-here>',
    -- },
  },
  options = {
    show_close_icon = false,
    indicator_icon = " ",
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
})
