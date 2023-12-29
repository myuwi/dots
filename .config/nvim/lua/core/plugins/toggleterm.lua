local function toggle_lazygit()
  require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", direction = "float" }):toggle()
end

return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>lg", toggle_lazygit, desc = "Open LazyGit" },
  },
}
