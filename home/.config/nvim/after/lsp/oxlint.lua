local util = require("util")

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root_dir = config.root_dir
    local oxlint_bin_path = util.from_node_modules("oxc_language_server", root_dir) or "oxc_language_server"

    if oxlint_bin_path == "oxc_language_server" then
      vim.notify(
        "Unable to find Oxc LS executable within current root directory, falling back to global installation.",
        vim.log.levels.WARN
      )
    end
    return vim.lsp.rpc.start({ oxlint_bin_path }, dispatchers)
  end,
  workspace_required = true,
}
