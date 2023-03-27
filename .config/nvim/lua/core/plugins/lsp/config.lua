local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local servers = {
  "eslint",
  "emmet_ls",
  "jsonls",
  "lemminx",
  "marksman",
  "prismals",
  "pyright",
  "rust_analyzer",
  "lua_ls",
  "svelte",
  "tailwindcss",
  "tsserver",
  "yamlls",
}

require("mason").setup()
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("core.plugins.lsp.handlers").on_attach,
    capabilities = require("core.plugins.lsp.handlers").capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, "core.plugins.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end
  lspconfig[server].setup(opts)
end
