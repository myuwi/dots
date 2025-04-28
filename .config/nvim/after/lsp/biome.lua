local util = require("core.util")

local biome_bin = util.from_node_modules("biome") or "biome"

---@type vim.lsp.Config
return {
  cmd = { biome_bin, "lsp-proxy" },
  workspace_required = true,
  on_init = function(client)
    if client.config.cmd[1] == "biome" then
      vim.notify(
        "Unable to find Biome executable within current working directory, falling back to global installation.",
        vim.log.levels.WARN
      )
    end
  end,
}
