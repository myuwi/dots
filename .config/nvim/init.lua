-- Disable config in VSCode NeoVim
if vim.g.vscode then
  return
end
require("user.keybinds")
require("user.plugins")
require("user.settings")
require("user.lsp")
require("user.cmp")
