local util = require("util")

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root_dir = config.root_dir
    local biome_bin_path = util.from_node_modules("biome", root_dir) or "biome"

    if biome_bin_path == "biome" then
      vim.notify("Unable to find Biome executable within current root directory, falling back to global installation.", vim.log.levels.WARN)
    end
    return vim.lsp.rpc.start({ biome_bin_path, "lsp-proxy" }, dispatchers)
  end,
  workspace_required = true,
}
