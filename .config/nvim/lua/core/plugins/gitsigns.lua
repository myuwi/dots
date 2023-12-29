return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      groups = {
        ["<leader>g"] = {
          name = "+Git",
          t = "+Toggle",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      on_attach = function(bufnr)
        local function opts(desc)
          return { buffer = bufnr, desc = desc, noremap = true, silent = true }
        end

        local gitsigns = require("gitsigns")

        vim.keymap.set("n", "<leader>gp", gitsigns.prev_hunk, opts("Previous Hunk"))
        vim.keymap.set("n", "<leader>gn", gitsigns.next_hunk, opts("Next Hunk"))
        vim.keymap.set("n", "<leader>gg", gitsigns.preview_hunk_inline, opts("Preview Hunk Inline"))
        vim.keymap.set("n", "<leader>gtb", gitsigns.toggle_current_line_blame, opts("Toggle Current Line Blame"))
        vim.keymap.set("n", "<leader>gtd", gitsigns.toggle_deleted, opts("Toggle Deleted"))
      end,
    },
  },
}
