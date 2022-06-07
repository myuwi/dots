require("luasnip").config.setup({
  history = false,
  update_events = "InsertLeave",
  enable_autosnippets = true,
  region_check_events = "CursorMoved,InsertEnter,InsertLeave",
  delete_check_events = "TextChanged,InsertEnter",
})
