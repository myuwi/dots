return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>g", group = "Git" },
        { "<leader>gt", desc = "+Toggle" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local function opts(desc)
          return { buffer = bufnr, desc = desc, noremap = true, silent = true }
        end

        local gitsigns = require("gitsigns")

        -- stylua: ignore start
        vim.keymap.set("n", "<leader>gp", function() gitsigns.nav_hunk("prev") end, opts("Previous Hunk"))
        vim.keymap.set("n", "<leader>gn", function() gitsigns.nav_hunk("next") end, opts("Next Hunk"))
        vim.keymap.set("n", "<leader>gg", gitsigns.preview_hunk_inline, opts("Preview Hunk Inline"))
        vim.keymap.set("n", "<leader>gtb", gitsigns.toggle_current_line_blame, opts("Toggle Current Line Blame"))
        vim.keymap.set("n", "<leader>gtd", gitsigns.preview_hunk_inline, opts("Toggle Deleted"))
        -- stylua: ignore end
      end,
    },
  },
}
