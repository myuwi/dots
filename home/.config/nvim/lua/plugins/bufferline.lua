---@module "snacks"

return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "rose-pine/neovim",
    "folke/snacks.nvim",
  },
  lazy = false,
  -- stylua: ignore
  keys = {
    { "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Cycle next buffer" },
    { "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Cycle previous buffer" },
    { "<C-A-j>", "<cmd>BufferLineMoveNext<CR>", desc = "Move current buffer forwards" },
    { "<C-A-k>", "<cmd>BufferLineMovePrev<CR>", desc = "Move current buffer backwards" },
    { "<Leader>bd", function() Snacks.bufdelete() end, desc = "Delete current buffer" },
  },
  opts = function()
    local p = require("rose-pine.palette")

    return {
      options = {
        indicator = { style = "none" },
        show_close_icon = false,
        persist_buffer_sort = false,
        separator_style = { "", "" },
        -- stylua: ignore start
        close_command = function(n) Snacks.bufdelete(n) end,
        middle_mouse_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = false,
        -- stylua: ignore end
        offsets = {
          { filetype = "NvimTree", highlight = "Normal" },
        },
      },
      highlights = {
        fill = { bg = p.base },

        background = { fg = p.highlight_high, bg = p.base },
        buffer_visible = { fg = p.highlight_high, bg = p.base },
        buffer_selected = { fg = p.text, bg = p.surface, bold = true },

        indicator_visible = { bg = p.base },
        indicator_selected = { bg = p.surface },

        duplicate = { fg = p.highlight_med, bg = p.base, italic = false },
        duplicate_visible = { fg = p.highlight_med, bg = p.base, italic = false },
        duplicate_selected = { fg = p.text, bg = p.surface, italic = false },

        close_button = { fg = p.highlight_high, bg = p.base },
        close_button_visible = { fg = p.highlight_high, bg = p.base },
        close_button_selected = { fg = p.text, bg = p.surface },

        modified = { fg = p.gold, bg = p.base },
        modified_visible = { fg = p.gold, bg = p.base },
        modified_selected = { fg = p.gold, bg = p.surface },

        pick = { fg = p.love, bg = p.base, bold = true, italic = true },
        pick_visible = { fg = p.love, bg = p.base, bold = true, italic = true },
        pick_selected = { fg = p.love, bg = p.surface, bold = true, italic = true },
      },
    }
  end,
}
