return {
  "nickjvandyke/opencode.nvim",
  -- stylua: ignore
  keys = {
    { "<leader>a", mode = {"n", "x"}, function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function() end,
        stop = function() end,
        toggle = function() end,
      },
    }
  end,
}
