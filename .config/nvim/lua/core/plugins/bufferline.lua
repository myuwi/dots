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
      },
      options = {
        show_close_icon = false,
        indicator = {
          style = "none",
        },
        separator_style = { "", "" },
        close_command = "Bdelete! %d",
        middle_mouse_command = "Bdelete! %d",
        right_mouse_command = false,
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
