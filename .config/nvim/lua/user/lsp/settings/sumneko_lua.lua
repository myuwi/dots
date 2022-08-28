local luadev = require("lua-dev").setup({
  -- add any options here, or leave empty to use the default settings
  -- lspconfig = {
  --   cmd = {"lua-language-server"}
  -- },
})

return luadev

-- return {
-- commands = {
--   Format = {
--     function()
--       require("stylua-nvim").format_file()
--     end,
--   },
-- },
-- }
