return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    config = function()
      local ts = require("nvim-treesitter")
      ts.install({
        "bash",
        "comment",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "lua",
        "luadoc",
        "luap",
        "markdown_inline",
        "nix",
        "printf",
        "regex",
        "yaml",
      })

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or not available[lang] then
            return
          end
          local function start()
            if vim.api.nvim_buf_is_valid(args.buf) then
              pcall(vim.treesitter.start, args.buf, lang)
            end
          end
          if vim.list_contains(ts.get_installed(), lang) then
            start()
          else
            ts.install(lang):await(vim.schedule_wrap(start))
          end
        end,
      })
    end,
  },
}
