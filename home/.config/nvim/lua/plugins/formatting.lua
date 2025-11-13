---@param bufnr integer
---@param formatters table<string, string[]>
---@return string|nil
local function find_closest_formatter(bufnr, formatters)
  local lspconfig_util = require("lspconfig.util")
  local current_buf_path = vim.api.nvim_buf_get_name(bufnr)
  local git_root = vim.fs.root(bufnr, ".git")
  local min_len = git_root and git_root:len() or 0

  local path_len = 0
  local closest_formatter = nil

  for _, formatter in ipairs(formatters) do
    local formatter_name = formatter[1]
    local root_files = formatter.root_files

    local root_dir = lspconfig_util.root_pattern(root_files)(current_buf_path)

    if root_dir and root_dir:len() > min_len and root_dir:len() > path_len then
      path_len = root_dir:len()
      closest_formatter = formatter_name
    end
  end

  return closest_formatter
end

local function javascript_formatters(bufnr)
  local project_formatter = find_closest_formatter(bufnr, {
    { "prettierd", root_files = { ".prettierrc*", "prettier.config.*" } },
    { "biome-check", root_files = { "biome.json", "biome.jsonc" } },
    { "deno_fmt", root_files = { "deno.json", "deno.jsonc" } },
  })

  local formatters = {
    project_formatter or "prettierd",
  }

  return formatters
end

return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    -- stylua: ignore
    { "<A-F>", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
  },
  opts = function(_, opts)
    opts.default_format_opts = {
      lsp_format = "fallback",
    }

    ---@type table<string, function|table>
    opts.formatters_by_ft = {
      go = { "goimports", "gofmt" },
      lua = { "stylua" },
      fennel = { "fnlfmt" },
      nu = { "topiary_nu" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      toml = { "taplo" },
      typst = { "typstyle" },

      graphql = { "prettierd" },
      handlebars = { "prettierd" },
    }

    local js_like = {
      "html",
      "css",
      "sass",
      "scss",
      "less",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",

      "astro",
      "vue",
      "svelte",

      "json",
      "jsonc",
      "yaml",
      "markdown",
      "markdown.mdx",
    }

    for _, ft in ipairs(js_like) do
      opts.formatters_by_ft[ft] = javascript_formatters
    end

    opts.formatters = {
      ["biome-check"] = { append_args = { "--indent-style=space" } },
      shfmt = { prepend_args = { "-i", "2" } },
      topiary_nu = {
        command = "topiary",
        args = { "format", "--language", "nu" },
      },
    }
  end,
}
