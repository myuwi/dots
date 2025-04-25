local function toggleterm_statusline()
  ---@diagnostic disable-next-line: undefined-field
  if vim.b.term_title:match("lazygit") then
    return "LazyGit"
  end

  ---@diagnostic disable-next-line: undefined-field
  return "ToggleTerm #" .. vim.b.toggle_number
end

local toggleterm = {
  sections = {
    lualine_a = { toggleterm_statusline },
  },
  filetypes = { "toggleterm" },
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "NVimTree" },
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "branch", icon = "󰘬" }, "diff", "diagnostics" },
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
    extensions = { "nvim-tree", toggleterm },
  },
}
