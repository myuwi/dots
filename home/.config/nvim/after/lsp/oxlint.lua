local util = require("util")

---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local git = vim.fs.root(bufnr, { ".git" })
    local configs = vim.fs.find(".oxlintrc.json", {
      upward = true,
      limit = math.huge,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
      stop = git and vim.fs.dirname(git) or nil,
    })

    on_dir(configs[#configs] and vim.fs.dirname(configs[#configs]) or git)
  end,
  cmd = function(dispatchers, config)
    local root_dir = config.root_dir
    local oxlint_bin_path = util.from_node_modules("oxlint", root_dir) or "oxlint"

    if oxlint_bin_path == "oxlint" then
      vim.notify(
        "Unable to find Oxlint executable within current root directory, falling back to global installation.",
        vim.log.levels.WARN
      )
    end
    return vim.lsp.rpc.start({ oxlint_bin_path, "--lsp" }, dispatchers)
  end,
  workspace_required = true,
  init_options = {
    settings = {
      -- typeAware = true,
    },
  },
}
