---@module "snacks"

return {
  "mfussenegger/nvim-lint",
  dependencies = { "folke/snacks.nvim" },
  enabled = false,
  opts = {
    events = { "BufWritePost", "BufReadPost", "TextChanged", "TextChangedI" },
    linters_by_ft = {},
  },
  config = function(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      desc = "lint buffer using nvim-lint",
      callback = Snacks.util.debounce(lint.try_lint, { ms = 200 }),
    })
  end,
}
