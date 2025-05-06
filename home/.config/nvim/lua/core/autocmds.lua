vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("auto-cd", { clear = true }),
  desc = "cd into directory",
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
    end
  end,
})
