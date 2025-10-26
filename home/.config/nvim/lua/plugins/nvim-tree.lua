---@module "snacks"

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
      group = vim.api.nvim_create_augroup("nvim-tree", { clear = true }),
      desc = "open nvim-tree on start",
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          local nvim_tree_api = require("nvim-tree.api")

          nvim_tree_api.tree.open()
          vim.cmd("vsplit +enew")
          vim.cmd("wincmd p")
          nvim_tree_api.tree.resize()
        end
      end,
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
    sync_root_with_cwd = true,
    filters = {
      git_ignored = false,
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
    renderer = {
      root_folder_label = false,
    },
    view = {
      signcolumn = "no",
    },
  },
}
