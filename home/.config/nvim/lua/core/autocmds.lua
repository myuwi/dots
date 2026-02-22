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
  group = vim.api.nvim_create_augroup("unlist-ephemeral-buffers", { clear = true }),
  pattern = { "qf", "help", "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<cmd>close<cr>", { silent = true })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("auto-close-empty-buffer", { clear = true }),
  callback = function()
    vim.defer_fn(function()
      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      if #bufs <= 1 then
        return
      end
      for _, buf in ipairs(bufs) do
        if buf.name == "" and buf.changed == 0 and buf.linecount <= 1 then
          pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = true })
        end
      end
    end, 0)
  end,
})
