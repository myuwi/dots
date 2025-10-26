local M = {}

---@param name string Name of the binary.
---@param path string? Path to start searching from.
---@return string?
function M.from_node_modules(name, path)
  return vim.fs.find("node_modules/.bin/" .. name, { upward = true, type = "file", path = path })[1]
end

return M
