return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
  },
  {
    "mks-h/treesitter-autoinstall.nvim",
    opts = {
      highlight = true,
    },
  },
}
