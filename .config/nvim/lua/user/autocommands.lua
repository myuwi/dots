local general = vim.api.nvim_create_augroup("general", { clear = true })

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
  group = general,
})
