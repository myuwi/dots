return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  opts = {
    extend_background_behind_borders = false,

    styles = {
      bold = false,
      italic = true,
      transparency = false,
    },
    groups = {
      border = "highlight_med",
    },
    highlight_groups = {
      NormalFloat = { bg = "NONE" },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd.colorscheme("rose-pine")
  end,
}
