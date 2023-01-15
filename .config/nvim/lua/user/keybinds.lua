local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = " "

local opts = { noremap = true }
local silent_opts = { noremap = true, silent = true }

-- Put in Visual Mode should not replace register
keymap("x", "p", "pgvy", opts)

-- Move lines with alt + jk
keymap("n", "<A-j>", "<cmd>m+<CR>==", opts)
keymap("n", "<A-k>", "<cmd>m-2<CR>==", opts)
keymap("i", "<A-j>", "<ESC><cmd>m+<CR>==gi", opts)
keymap("i", "<A-k>", "<ESC><cmd>m-2<CR>==gi", opts)
-- TODO: possible to use <cmd> instead?
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", silent_opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", silent_opts)

-- Indentation
keymap("v", ">", ">gv", opts)
keymap("v", "<", "<gv", opts)

keymap("n", "<Tab><Tab>", ">>", opts)
keymap("n", "<S-Tab><S-Tab>", "<<", opts)
keymap("v", "<Tab>", ">gv", opts)
keymap("v", "<S-Tab>", "<gv", opts)

-- Buffer navigation
-- navigate splits
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- cycle buffer
keymap("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", opts)
keymap("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", opts)

-- move buffer
keymap("n", "<Leader>bn", "<cmd>BufferLineMoveNext<CR>", opts)
keymap("n", "<Leader>bp", "<cmd>BufferLineMovePrev<CR>", opts)

-- delete buffer
keymap("n", "<Leader>bd", "<cmd>Bdelete<CR>", opts)

-- Toggle NvimTree
keymap("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", opts)

-- Telescope
keymap("n", "<C-p>", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<Leader>pf", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<Leader>pg", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<Leader>pb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<Leader>ph", "<cmd>Telescope help_tags<CR>", opts)
