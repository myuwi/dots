return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    indent = { enabled = true, scope = { enabled = false }, indent = { char = "▎" } },
    lazygit = { configure = false },
  },
  -- stylua: ignore
  keys = {
    { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit", },
  },
}
