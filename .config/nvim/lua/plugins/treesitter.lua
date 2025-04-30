return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  ---@module "nvim-treesitter.configs"
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    ensure_installed = { "lua", "json", "toml", "comment", "markdown", "markdown_inline" },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@call.outer",
          ["ic"] = "@call.inner",
        },
        include_surrounding_whitespace = true,
      },
    },
  },
}
