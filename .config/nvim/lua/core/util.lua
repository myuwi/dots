local M = {}

---@param name string Name of the binary.
---@return string?
function M.from_node_modules(name)
  return vim.fs.find("node_modules/.bin/" .. name, { upward = true, type = "file" })[1]
end

return M
