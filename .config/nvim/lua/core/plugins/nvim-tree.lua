return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/snacks.nvim",
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

    local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
    vim.api.nvim_create_autocmd("User", {
      pattern = "NvimTreeSetup",
      callback = function()
        local events = require("nvim-tree.api").events
        events.subscribe(events.Event.NodeRenamed, function(data)
          if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
            data = data
            Snacks.rename.on_rename_file(data.old_name, data.new_name)
          end
        end)
      end,
    })
  end,
  opts = {
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    renderer = {
      root_folder_label = false,
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
