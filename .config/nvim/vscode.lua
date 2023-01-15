local keymap = vim.api.nvim_set_keymap

local opts = { noremap = true }
local silent_opts = { noremap = true, silent = true }

-- Put in Visual Mode should not replace register
keymap("x", "p", "pgvy", opts)

-- Move lines with alt + jk
keymap("n", "<A-j>", "<cmd>call VSCodeNotify('editor.action.moveLinesDownAction')<CR>", opts)
keymap("n", "<A-k>", "<cmd>call VSCodeNotify('editor.action.moveLinesUpAction')<CR>", opts)

-- keymap("n", "<A-j>", "<cmd>m+<CR>==", opts)
-- keymap("n", "<A-k>", "<cmd>m-2<CR>==", opts)
-- keymap("i", "<A-j>", "<ESC><cmd>m+<CR>==gi", opts)
-- keymap("i", "<A-k>", "<ESC><cmd>m-2<CR>==gi", opts)
-- -- TODO: possible to use <cmd> instead?
-- keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", silent_opts)
-- keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", silent_opts)

-- Indentation
keymap("v", ">", ">gv", opts)
keymap("v", "<", "<gv", opts)

keymap("n", "<Tab><Tab>", ">>", opts)
keymap("n", "<S-Tab><S-Tab>", "<<", opts)
keymap("v", "<Tab>", ">gv", opts)
keymap("v", "<S-Tab>", "<gv", opts)

--
-- Settings
--

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.breakindent = true

vim.opt.clipboard = "unnamedplus"

vim.opt.iskeyword:append("-")
