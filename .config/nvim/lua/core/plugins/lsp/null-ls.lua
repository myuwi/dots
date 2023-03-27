local null_ls = require("null-ls")

null_ls.setup({
  on_attach = require("core.plugins.lsp.handlers").on_attach,
  sources = {
    -- Lua
    null_ls.builtins.formatting.stylua,
    -- JS, TS, etc.
    null_ls.builtins.formatting.prettierd.with({
      extra_filetypes = { "svelte" },
    }),
    -- Python
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    -- TOML
    null_ls.builtins.formatting.taplo,
    -- Shell
    null_ls.builtins.formatting.shfmt,
    -- Shellcheck causes a memory leak for some reason
    -- null_ls.builtins.diagnostics.shellcheck,
    -- null_ls.builtins.code_actions.shellcheck,
  },
})
