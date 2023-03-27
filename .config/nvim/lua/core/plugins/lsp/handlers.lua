local Set = require("core.helpers").Set

local M = {}

-- local border = "rounded"
local border = {
  { " ", "FloatBorder" },
  { " ", "FloatBorder" },
  { " ", "FloatBorder" },
  { " ", "FloatBorder" },
  { " ", "FloatBorder" },
  { " ", "FloatBorder" },
  { " ", "FloatBorder" },
  { " ", "FloatBorder" },
}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = border,
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  })
end

local function lsp_keymaps(bufnr)
  ---@param desc string
  local function opts(desc)
    return { buffer = bufnr, desc = desc, noremap = true, silent = true }
  end

  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts("Show diagnostics in floating window"))
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts("Add buffer diagnostics to the location list"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Jump to the declaration of the symbol under the cursor"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Jump to the definition of the symbol under the cursor"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Display hover information about the symbol under the cursor in a floating window"))
  -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  -- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  -- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  -- vim.keymap.set("n", "<leader>wl", function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts("Jump to the definition of the type of the symbol under the cursor"))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename all references to the symbol under the cursor"))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Select a code action available at the current cursor position"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("List all the references to the symbol under the cursor in the quickfix window"))
  vim.keymap.set("n", "<A-F>", function()
    vim.lsp.buf.format({ async = true })
  end, opts("Formats a buffer using the attached language server clients"))
end

local disabled_formatters = Set({
  "jsonls",
  "lua_ls",
  "tsserver",
})

M.on_attach = function(client, bufnr)
  if disabled_formatters[client.name] then
    client.server_capabilities.documentFormattingProvider = false
  end
  lsp_keymaps(bufnr)
  -- TODO: https://github.com/RRethy/vim-illuminate
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
return M
