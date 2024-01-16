return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  tag = "v1.2.2",
  opts = {
    disable_float_background = true,
    highlight_groups = {
      DiagnosticUnnecessary = {},
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd.colorscheme("rose-pine")
  end,
}
