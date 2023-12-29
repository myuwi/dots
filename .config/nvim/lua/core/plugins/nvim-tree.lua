return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = {
        ["tailwind.config.js"] = { icon = "󱏿", color = "#4db6ac", name = "Tailwind" },
        ["tailwind.config.cjs"] = { icon = "󱏿", color = "#4db6ac", name = "Tailwind" },
        ["tailwind.config.mjs"] = { icon = "󱏿", color = "#4db6ac", name = "Tailwind" },
        ["tailwind.config.ts"] = { icon = "󱏿", color = "#4db6ac", name = "Tailwind" },
      },
    },
  },
  keys = {
    { "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle Nvim-Tree" },
  },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(data)
        local directory = vim.fn.isdirectory(data.file) == 1

        if not directory then
          return
        end

        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open()
      end,
      desc = "cd into directory and open nvim-tree on start",
      group = vim.api.nvim_create_augroup("nvim-tree", { clear = true }),
    })
  end,
  opts = {
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = false,
      icons = {
        hint = "H",
        info = "I",
        warning = "W",
        error = "E",
      },
    },
    git = {
      enable = true,
      ignore = false,
      timeout = 400,
    },
  },
}
