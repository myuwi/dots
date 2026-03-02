local function on_attach(client, bufnr)
  ---@param desc string
  local function opts(desc)
    return { buffer = bufnr, desc = desc, noremap = true, silent = true }
  end

  -- stylua: ignore
  do
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
  end

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

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
    "b0o/schemastore.nvim",
    { "folke/neoconf.nvim", opts = {} },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  opts = {
    servers = {
      "biome",
      "clojure_lsp",
      { "denols", opts = { mason = false } },
      "elixirls",
      "emmet_ls",
      "eslint",
      "fennel_ls",
      { "gleam", opts = { mason = false } },
      "glsl_analyzer",
      "gopls",
      "jsonls",
      "lemminx",
      "marksman",
      "nushell",
      { "oxlint", opts = { mason = false } },
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
    local mason_lspconfig = require("mason-lspconfig")
    local mason_lspconfig_servers = vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        on_attach(client, bufnr)
      end,
    })

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    local ensure_installed = {}

    for _, server in ipairs(opts.servers) do
      server = type(server) == "table" and server or { server }

      local server_name = server[1]
      local server_opts = server.opts or {}

      local use_mason = server_opts.mason ~= false and vim.tbl_contains(mason_lspconfig_servers, server_name)

      if use_mason then
        ensure_installed[#ensure_installed + 1] = server_name
      else
        vim.lsp.enable(server_name)
      end
    end

    mason_lspconfig.setup({
      automatic_enable = true,
      ensure_installed = ensure_installed,
    })

    vim.diagnostic.config(opts.diagnostic)
  end,
}
