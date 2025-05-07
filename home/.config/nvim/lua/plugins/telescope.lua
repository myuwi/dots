return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>p", group = "Telescope" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        { "<C-p>", builtin.find_files, desc = "Telescope: Find Files" },
        { "<leader>pf", builtin.find_files, desc = "Telescope: Find Files" },
        { "<leader>pg", builtin.live_grep, desc = "Telescope: Live Grep" },
        { "<leader>ph", builtin.help_tags, desc = "Telescope: Help Tags" },
        { "<leader>pb", builtin.buffers, desc = "Telescope: Buffers" },
      }
    end,
    opts = {
      defaults = {
        file_ignore_patterns = {
          "^.git/",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        grep_string = {
          additional_args = { "--hidden" },
        },
        live_grep = {
          additional_args = { "--hidden" },
        },
      },
    },
  },
}
