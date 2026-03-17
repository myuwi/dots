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
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
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
        entry_prefix = " ",
        selection_caret = " ",
        prompt_prefix = " > ",
        layout_strategy = "horizontal_merged",
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = { "--hidden" },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local layout_strategies = require("telescope.pickers.layout_strategies")

      layout_strategies.horizontal_merged = function(picker, max_columns, max_lines, layout_config)
        local layout = layout_strategies.horizontal(picker, max_columns, max_lines, layout_config)

        layout.results.borderchars = { "─", "│", "─", "│", "╭", "╮", "│", "│" }
        layout.results.height = layout.results.height + 1
        layout.results.title = layout.prompt.title

        return layout
      end

      telescope.load_extension("fzf")
      telescope.setup(opts)
    end,
  },
}
