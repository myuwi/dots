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
    dependencies = "nvim-lua/plenary.nvim",
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
          ".netlify/",
          ".svelte%-kit/",
          "node_modules",
          "target",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "-uu",
        },
      },
      pickers = {
        find_files = {
          no_ignore = true,
          hidden = true,
        },
        live_grep = {
          no_ignore = true,
          hidden = true,
        },
      },
    },
  },
}
