-- Many tools in node_modules/.bin run through `#!/usr/bin/env node`. When only
-- bun is available, alias node to it for everything Neovim spawns.
if vim.fn.executable("node") == 1 or vim.fn.executable("bun") == 0 then
  return
end

local dir = vim.fs.joinpath(vim.fs.dirname(vim.fn.tempname()), "bun-node")
vim.fn.mkdir(dir, "p")
vim.uv.fs_symlink(vim.fn.exepath("bun"), vim.fs.joinpath(dir, "node"))
vim.env.PATH = dir .. ":" .. vim.env.PATH
