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
    opts = {
      servers = {
        { "biome", opts = { mason = false } },
        "clojure_lsp",
        { "denols", opts = { mason = false } },
        "elixirls",
        "emmet_ls",
        "eslint",
        "fennel_ls",
        { "gleam", opts = { mason = false } },
        "gopls",
        "jsonls",
        "lemminx",
        "marksman",
        "prismals",
        "pyright",
        { "rust_analyzer", opts = { mason = false } },
        "lua_ls",
        "svelte",
        "tailwindcss",
        "taplo",
        "tinymist",
        "ts_ls",
        "yamlls",
      },
      ---@type vim.diagnostic.Opts
      diagnostic = {
        virtual_text = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          border = "single",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_lspconfig_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      require("mason").setup()

      local function setup(server_name)
        local server_opts = {
          on_attach = require("core.plugins.lsp.handlers").on_attach,
          capabilities = require("core.plugins.lsp.handlers").capabilities,
        }

        local has_override_opts, override_opts = pcall(require, "core.plugins.lsp.servers." .. server_name)
        if has_override_opts then
          server_opts = vim.tbl_deep_extend("force", server_opts, override_opts)
        end

        lspconfig[server_name].setup(server_opts)
      end

      local ensure_installed = {}

      for _, server in ipairs(opts.servers) do
        local server_name = type(server) == "table" and server[1] or server
        local server_opts = type(server) == "table" and server.opts or {}

        if server_opts.mason == false or not vim.tbl_contains(mason_lspconfig_servers, server_name) then
          setup(server_name)
        else
          ensure_installed[#ensure_installed + 1] = server_name
        end
      end

      mason_lspconfig.setup({
        ensure_installed = ensure_installed,
        automatic_installation = false,
        handlers = { setup },
      })

      vim.diagnostic.config(opts.diagnostic)
    end,
  },
}
