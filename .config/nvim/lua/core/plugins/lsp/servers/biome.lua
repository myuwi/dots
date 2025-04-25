---@type vim.lsp.Config
return {
  cmd = { "bunx", "--bun", "@biomejs/biome", "lsp-proxy" },
}
