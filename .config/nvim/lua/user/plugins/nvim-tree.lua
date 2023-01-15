require("nvim-tree").setup({
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
})
