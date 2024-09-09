local function format()
  require("conform").format()
end

return {
  "stevearc/conform.nvim",
  keys = {
    { "<A-F>", format, desc = "Format a buffer using the installed formatters" },
  },
  opts = function(_, opts)
    opts.default_format_opts = {
      async = true,
      lsp_format = "fallback",
    }

    opts.formatters_by_ft = {
      go = { "goimports", "gofmt" },
      lua = { "stylua" },
      fennel = { "fnlfmt" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      toml = { "taplo" },
    }

    local prettier_filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "css",
      "scss",
      "less",
      "html",
      "json",
      "jsonc",
      "yaml",
      "markdown",
      "markdown.mdx",
      "graphql",
      "handlebars",
    }

    for _, ft in ipairs(prettier_filetypes) do
      opts.formatters_by_ft[ft] = { "prettierd", "prettier", stop_after_first = true }
    end

    opts.formatters = {
      shfmt = { prepend_args = { "-i", "2" } },
    }
  end,
}
