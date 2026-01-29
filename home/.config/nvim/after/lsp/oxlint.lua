local util = require("util")

---@type vim.lsp.Config
return {
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
      typeAware = true,
    },
  },
}
