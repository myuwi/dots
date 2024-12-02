---@param bufnr integer
---@param formatters table<string, string[]>
---@return string|nil
local function find_closest_formatter(bufnr, formatters)
  local current_buf_path = vim.api.nvim_buf_get_name(bufnr)
  local git_root = require("lspconfig.util").find_git_ancestor(current_buf_path)
  local min_len = git_root and git_root:len() or 0

  local path_len = 0
  local closest_formatter = nil

  for formatter, root_files in pairs(formatters) do
    local unpack = unpack or table.unpack
    local root_dir = require("lspconfig.util").root_pattern(unpack(root_files))(current_buf_path)

    if root_dir and root_dir:len() >= min_len and root_dir:len() > path_len then
      path_len = root_dir:len()
      closest_formatter = formatter
    end
  end

  return closest_formatter
end

local rustywind_ft = {
  "html",
  "css",
  "sass",
  "scss",
  "less",
  "javascriptreact",
  "typescriptreact",
  "astro",
  "vue",
  "svelte",
}

local function should_format_tailwind(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr, name = "tailwindcss" }) and vim.tbl_contains(rustywind_ft, vim.bo[bufnr].filetype)
end

local function javascript_formatters(bufnr)
  local project_formatter = find_closest_formatter(bufnr, {
    prettierd = { ".prettierrc*", "prettier.config.{js,cjs,mjs}" },
    deno_fmt = { "deno.json", "deno.jsonc" },
  })

  local formatters = {
    project_formatter or "prettierd",
  }

  if should_format_tailwind(bufnr) then
    table.insert(formatters, "rustywind")
  end

  return formatters
end

return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    -- stylua: ignore
    { "<A-F>", function() require("conform").format() end, desc = "Format buffer" },
  },
  opts = function(_, opts)
    opts.default_format_opts = {
      async = true,
      lsp_format = "fallback",
    }

    ---@type table<string, function|table>
    opts.formatters_by_ft = {
      go = { "goimports", "gofmt" },
      lua = { "stylua" },
      fennel = { "fnlfmt" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      toml = { "taplo" },
      typst = { "typstyle" },

      graphql = { "prettierd" },
      handlebars = { "prettierd" },
    }

    local deno_or_prettier_ft = {
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

    for _, ft in ipairs(deno_or_prettier_ft) do
      opts.formatters_by_ft[ft] = javascript_formatters
    end

    opts.formatters = {
      shfmt = { prepend_args = { "-i", "2" } },
      rustywind = {
        prepend_args = {
          "--custom-regex",
          [=[(?:\bclass(?:Name)*\s*=\s*["']|@apply )([_a-zA-Z0-9\.\s\-:\[\]\/]+)["';]]=],
        },
      },
    }
  end,
}
