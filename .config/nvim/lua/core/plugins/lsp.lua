return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = "nvim-lua/plenary.nvim",
      },
      "b0o/schemastore.nvim",
      {
        "folke/neodev.nvim",
        config = true,
      },
    },
    config = function()
      require("core.plugins.lsp.config")
      require("core.plugins.lsp.handlers").setup()
      require("core.plugins.lsp.null-ls")
    end,
  },

  { "Fymyte/rasi.vim", ft = "rasi" },
  { "elkowar/yuck.vim", ft = "yuck" },
}
