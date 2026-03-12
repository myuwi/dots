return {
  "nickjvandyke/opencode.nvim",
  -- stylua: ignore
  keys = {
    { "<leader>oa", mode = {"n", "x"}, function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type or field for details
      server = {
        start = function() end,
        stop = function() end,
        toggle = function() end,
      },
    }
  end,
}
