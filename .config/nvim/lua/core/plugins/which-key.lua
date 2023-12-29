return {
  "folke/which-key.nvim",
  opts = {},
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.groups)
  end,
}
