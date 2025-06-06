vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("auto-cd", { clear = true }),
  desc = "cd into directory",
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<cmd>close<cr>", { silent = true })
  end,
})
