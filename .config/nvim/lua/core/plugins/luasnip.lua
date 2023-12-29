return {
  "L3MON4D3/LuaSnip",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local luasnip = require("luasnip")
    local fmt = require("luasnip.extras.fmt").fmt
    local snippet = luasnip.snippet
    local function_node = luasnip.function_node
    local insert_node = luasnip.insert_node

    require("luasnip/loaders/from_vscode").lazy_load()

    luasnip.setup({
      history = false,
      update_events = { "InsertLeave", "TextChanged", "TextChangedI" },
      enable_autosnippets = true,
      region_check_events = { "CursorMoved", "InsertEnter", "InsertLeave" },
      delete_check_events = { "TextChanged", "InsertEnter", "InsertLeave" },
    })

    luasnip.add_snippets("lua", {
      snippet(
        "rq",
        fmt([[local {} = require("{}")]], {
          function_node(function(import_name)
            local parts = vim.split(import_name[1][1], ".", { plain = true })
            return parts[#parts] or ""
          end, { 1 }),
          insert_node(1, "module"),
        })
      ),
    })
  end,
}
