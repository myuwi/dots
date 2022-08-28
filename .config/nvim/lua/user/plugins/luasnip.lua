local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node

ls.config.setup({
  history = false,
  update_events = "InsertLeave,TextChanged,TextChangedI",
  enable_autosnippets = true,
  region_check_events = "CursorMoved,InsertEnter,InsertLeave",
  delete_check_events = "TextChanged,InsertEnter",
})

ls.add_snippets("lua", {
  s(
    "rq",
    fmt([[local {} = require("{}")]], {
      f(function(import_name)
        local parts = vim.split(import_name[1][1], ".", true)
        return parts[#parts] or ""
      end, { 1 }),
      i(1, "module"),
    })
  ),
})
