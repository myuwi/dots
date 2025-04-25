local M = {}

M.on_attach = function(client, bufnr)
  ---@param desc string
  local function opts(desc)
    return { buffer = bufnr, desc = desc, noremap = true, silent = true }
  end

  -- stylua: ignore start
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts("Show diagnostics in floating window"))
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts("Add buffer diagnostics to the location list"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Jump to the declaration of the symbol under the cursor"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Jump to the definition of the symbol under the cursor"))
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "single" }) end, opts("Display hover information about the symbol under the cursor in a floating window"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Lists all the implementations for the symbol under the cursor"))
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts("Jump to the definition of the type of the symbol under the cursor"))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename all references to the symbol under the cursor"))
  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts("Rename all references to the symbol under the cursor"))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Select a code action available at the current cursor position"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("List all the references to the symbol under the cursor"))
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

return M
