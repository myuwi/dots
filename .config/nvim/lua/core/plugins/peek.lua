return {
  "toppair/peek.nvim",
  build = "deno task --quiet build:fast",
  config = function()
    local peek = require("peek")

    vim.api.nvim_create_user_command("PeekOpen", function()
      if not peek.is_open() then
        peek.open()
      end
    end, {})
    vim.api.nvim_create_user_command("PeekClose", function()
      if peek.is_open() then
        peek.close()
      end
    end, {})
  end,
}
