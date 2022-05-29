require("nvim-tree").setup({
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
})
