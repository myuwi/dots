return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "*",
  dependencies = { "rafamadriz/friendly-snippets" },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = { border = "single" },
      },
      ghost_text = { enabled = true },
      list = { selection = { preselect = false } },
      menu = {
        auto_show = function()
          return not require("blink.cmp").snippet_active()
        end,
        max_height = 24,
        draw = {
          columns = {
            { "kind_icon", "label", gap = 1 },
            { "source_name" },
          },
        },
      },
    },
    cmdline = {
      keymap = {
        preset = "inherit",
        ["<Esc>"] = { "cancel", "fallback" },
        ["<Tab>"] = { "show", "select_next", "fallback" },
        ["<S-Tab>"] = { "show", "select_prev", "fallback" },
      },
    },
    sources = {
      default = { "lazydev", "lsp", "snippets", "path", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
  },
}
