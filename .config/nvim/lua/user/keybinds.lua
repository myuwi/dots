local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = " "

local opts = { noremap = true }
local silent_opts = { noremap = true, silent = true }

-- Buffer navigation
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<Leader>bn", "<cmd>BufferLineCycleNext<CR>", opts)
keymap("n", "<Leader>bp", "<cmd>BufferLineCyclePrev<CR>", opts)
keymap("n", "<Leader>bd", "<cmd>Bdelete<CR>", opts)

keymap("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", opts)
keymap("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", opts)

-- Toggle NvimTree
keymap("n", "<C-b>", ":NvimTreeToggle<CR>", silent_opts)

-- LSP
keymap("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- Telescope
keymap("n", "<C-p>", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<Leader>pf", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<Leader>pg", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<Leader>pb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<Leader>ph", "<cmd>Telescope help_tags<CR>", opts)

-- Put in Visual Mode should not replace register
keymap("x", "p", "pgvy", opts)
