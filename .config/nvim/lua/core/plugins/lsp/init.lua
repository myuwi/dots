return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neoconf.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      { "folke/neodev.nvim", opts = {} },
    },
    opts = function()
      local float = {
        focusable = true,
        style = "minimal",
        border = "single",
      }

      return {
        servers = {
          "clojure_lsp",
          "eslint",
          "emmet_ls",
          "fennel_ls",
          "gopls",
          "jsonls",
          "lemminx",
          "marksman",
          "prismals",
          "pyright",
          "rust_analyzer",
          "lua_ls",
          "svelte",
          "tailwindcss",
          "typst_lsp",
          "ts_ls",
          "yamlls",
        },
        signs = {
          { name = "DiagnosticSignError", text = "" },
          { name = "DiagnosticSignWarn", text = "" },
          { name = "DiagnosticSignHint", text = "" },
          { name = "DiagnosticSignInfo", text = "" },
        },
        float = float,
        diagnostic = {
          virtual_text = true,
          update_in_insert = true,
          underline = true,
          severity_sort = true,
          float = float,
        },
      }
    end,
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      require("mason").setup()

      local function setup(server_name)
        local server_opts = {
          on_attach = require("core.plugins.lsp.handlers").on_attach,
          capabilities = require("core.plugins.lsp.handlers").capabilities,
        }

        local has_custom_opts, override_opts = pcall(require, "core.plugins.lsp.servers." .. server_name)
        if has_custom_opts then
          server_opts = vim.tbl_deep_extend("force", server_opts, has_custom_opts and override_opts or {})
        end

        lspconfig[server_name].setup(server_opts)
      end

      mason_lspconfig.setup({
        ensure_installed = opts.servers,
        automatic_installation = true,
        handlers = { setup },
      })

      for _, sign in ipairs(opts.signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      vim.diagnostic.config(opts.diagnostic)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, opts.float)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, opts.float)
    end,
  },
}
