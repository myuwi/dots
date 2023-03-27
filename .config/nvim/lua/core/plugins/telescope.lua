return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    defaults = {
      file_ignore_patterns = {
        "^.git/",
        ".svelte%-kit/",
        ".netlify/",
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
        hidden = true,
        no_ignore = true,
      },
      live_grep = {
        hidden = true,
      },
    },
  },
  config = function()
    local set_keymap = require("core.helpers").set_keymap
    local builtin = require("telescope.builtin")
    set_keymap("n", "<C-p>", builtin.find_files, { desc = "Telescope: Find Files" })
    set_keymap("n", "<Leader>pf", builtin.find_files, { desc = "Telescope: Find Files" })
    set_keymap("n", "<Leader>pg", builtin.live_grep, { desc = "Telescope: Live Grep" })
    set_keymap("n", "<Leader>ph", builtin.help_tags, { desc = "Telescope: Help Tags" })
    set_keymap("n", "<Leader>pb", builtin.buffers, { desc = "Telescope: Buffers" })
  end,
}
