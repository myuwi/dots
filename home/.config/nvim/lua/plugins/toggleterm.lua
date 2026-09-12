local function toggle(cmd)
  return function()
    require("toggleterm.terminal").Terminal:new({ cmd = cmd, direction = "float" }):toggle()
  end
end

return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>lg", toggle("lazygit"), desc = "Open LazyGit" },
  },
  opts = function()
    local highlights = require("rose-pine.plugins.toggleterm")
    return {
      highlights = highlights,
      float_opts = {
        border = "curved",
      },
    }
  end,
}
