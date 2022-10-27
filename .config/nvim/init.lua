require("user.settings")

-- Disable config in VSCode Neovim
if vim.g.vscode then
  return
end

require("user.keybinds")
require("user.plugins")
require("user.lsp")
require("user.cmp")
