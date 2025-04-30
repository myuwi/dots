---@param fn function
---@param ms integer
local function debounce(fn, ms)
  local timer = vim.loop.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

return {
  "mfussenegger/nvim-lint",
  opts = {
    events = { "BufWritePost", "BufReadPost", "TextChanged", "TextChangedI" },
    linters_by_ft = {
      python = { "flake8" },
    },
  },
  config = function(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft

    local function try_lint()
      lint.try_lint()
    end

    vim.api.nvim_create_autocmd(opts.events, {
      callback = debounce(try_lint, 300),
      desc = "lint buffer using nvim-lint",
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    })
  end,
}
