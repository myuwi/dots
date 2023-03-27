return {
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
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "bmv", "", { buffer = bufnr })
      vim.keymap.del("n", "bmv", { buffer = bufnr })
    end,
  },
}
