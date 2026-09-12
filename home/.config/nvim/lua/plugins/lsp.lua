local function on_attach(_client, bufnr)
  ---@param desc string
  local function opts(desc)
    return { buffer = bufnr, desc = desc, noremap = true, silent = true }
  end

  local function hover()
    vim.lsp.buf.hover({ border = "single" })
    vim.lsp.buf.document_highlight()
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      once = true,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end

  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts("Show diagnostics"))
  vim.keymap.set("n", "K", hover, opts("Hover symbol"))
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts("Add diagnostics to location list"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts("Go to type definition"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Find references"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Find implementations"))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts("Rename symbol"))
  vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, opts("Code action"))
  vim.keymap.set("n", "<leader>gR", "<cmd>LspRestart<CR>", opts("Restart LSP client"))
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
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
      "denols",
      "elixirls",
      "emmet_ls",
      "eslint",
      "fennel_ls",
      "gleam",
      "gopls",
      "jsonls",
      "lua_ls",
      "marksman",
      "nixd",
      "nushell",
      "oxlint",
      "qmlls",
      "rust_analyzer",
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
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        on_attach(client, bufnr)
      end,
    })

    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    vim.lsp.enable(opts.servers)
    vim.diagnostic.config(opts.diagnostic)
  end,
}
