return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "<leader>gp", gs.prev_hunk, "Previous Hunk")
        map("n", "<leader>gn", gs.next_hunk, "Next Hunk")
        map("n", "<leader>gg", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle Current Line Blame")
        map("n", "<leader>gtd", gs.toggle_deleted, "Toggle Deleted")

        map({ "o", "x" }, "ih", gs.select_hunk, "GitSigns Select Hunk")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
}
