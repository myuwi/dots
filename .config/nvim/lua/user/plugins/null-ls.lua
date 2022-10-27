local null_ls = require("null-ls")

null_ls.setup({
  on_attach = require("user.lsp.handlers").on_attach,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.taplo,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.fnlfmt,
  },
})
