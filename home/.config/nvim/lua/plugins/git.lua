return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>g", group = "Git" },
      },
    },
  },
  {
    "nvim-mini/mini.diff",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>go", function() require("mini.diff").toggle_overlay(0) end, desc = "Toggle mini.diff overlay" },
    },
    opts = {
      view = { style = "sign" },
      mappings = {
        goto_first = "[G",
        goto_last = "]G",
        goto_prev = "[g",
        goto_next = "]g",
      },
      options = {
        algorithm = "myers",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
    },
  },
}
