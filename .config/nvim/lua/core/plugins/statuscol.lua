return {
  "luukvbaal/statuscol.nvim",
  dependencies = "lewis6991/gitsigns.nvim",
  opts = function()
    local builtin = require("statuscol.builtin")
    local gitsigns = require("gitsigns")
    local gitsigns_click = gitsigns.preview_hunk_inline

    return {
      ft_ignore = { "NvimTree" },
      segments = {
        {
          sign = { name = { "Diagnostic" }, maxwidth = 1, colwidth = 2 },
          click = "v:lua.ScSa",
        },
        {
          sign = { name = { ".*" }, maxwidth = 1, colwidth = 2, auto = true },
          click = "v:lua.ScSa",
        },
        {
          sign = { namespace = { "gitsigns" }, maxwidth = 1, colwidth = 2 },
          click = "v:lua.ScSa",
        },
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        },
        {
          text = { builtin.foldfunc, " " },
          click = "v:lua.ScFa",
        },
      },
      clickhandlers = {
        FoldOpen = function(args)
          if args.button == "l" then
            builtin.foldopen_click(args)
          end
        end,
        FoldClose = function(args)
          if args.button == "l" then
            builtin.foldclose_click(args)
          end
        end,
        FoldOther = false,
        GitSignsTopdelete = gitsigns_click,
        GitSignsUntracked = gitsigns_click,
        GitSignsAdd = gitsigns_click,
        GitSignsChange = gitsigns_click,
        GitSignsChangedelete = gitsigns_click,
        GitSignsDelete = gitsigns_click,
        gitsigns_extmark_signs_ = gitsigns_click,
      },
    }
  end,
}
