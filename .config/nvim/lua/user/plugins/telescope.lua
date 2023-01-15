require("telescope").setup({
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
})
