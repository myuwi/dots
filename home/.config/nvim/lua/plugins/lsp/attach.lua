local function on_attach(client, bufnr)
  ---@param desc string
  local function opts(desc)
    return { buffer = bufnr, desc = desc, noremap = true, silent = true }
  end

  -- stylua: ignore start
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts("Show diagnostics"))
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "single" }) end, opts("Hover symbol"))
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts("Add diagnostics to location list"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts("Go to type definition"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Find references"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Find implementations"))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts("Rename symbol"))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
  vim.keymap.set("n", "<leader>gR", "<cmd>LspRestart<CR>", opts("Restart LSP client"))
  -- stylua: ignore end

  -- TODO: Refresh when it becomes available?
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh()
      end,
    })
  end
end

return on_attach
