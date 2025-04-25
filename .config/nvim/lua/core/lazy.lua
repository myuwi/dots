local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Import the main which-key spec first so it uses opts_extended correctly
    { import = "core.plugins.which-key" },
    { import = "core.plugins" },
  },
  change_detection = { notify = false },
  install = {
    colorscheme = { "rose-pine" },
  },
})
