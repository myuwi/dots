local set_keymap = require("core.helpers").set_keymap

-- Put in Visual Mode should not replace register
set_keymap("x", "p", "pgvy")

-- Move lines with alt + jk
set_keymap("n", "<A-j>", "<cmd>m+<CR>==", { desc = "Move current line down" })
set_keymap("n", "<A-k>", "<cmd>m-2<CR>==", { desc = "Move current line up" })
set_keymap("i", "<A-j>", "<ESC><cmd>m+<CR>==gi", { desc = "Move current line down" })
set_keymap("i", "<A-k>", "<ESC><cmd>m-2<CR>==gi", { desc = "Move current line up" })
-- TODO: possible to use <cmd> instead?
set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected line(s) down" })
set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected line(s) up" })

-- Indentation
set_keymap("n", "<Tab><Tab>", ">>", { desc = "Indent current line" })
set_keymap("n", "<S-Tab><S-Tab>", "<<", { desc = "Unindent current line" })

set_keymap("v", ">", ">gv", { desc = "Indent selected line(s)" })
set_keymap("v", "<", "<gv", { desc = "Unindent selected line(s)" })
set_keymap("v", "<Tab>", ">gv", { desc = "Indent selected line(s)" })
set_keymap("v", "<S-Tab>", "<gv", { desc = "Unindent selected line(s)" })

-- Buffer navigation
-- navigate splits
set_keymap("n", "<C-h>", "<C-w>h")
set_keymap("n", "<C-j>", "<C-w>j")
set_keymap("n", "<C-k>", "<C-w>k")
set_keymap("n", "<C-l>", "<C-w>l")

-- cycle buffer
set_keymap("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>")
set_keymap("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>")

-- move buffer
set_keymap("n", "<C-A-j>", "<cmd>BufferLineMoveNext<CR>")
set_keymap("n", "<C-A-k>", "<cmd>BufferLineMovePrev<CR>")

-- delete buffer
set_keymap("n", "<Leader>bd", "<cmd>Bdelete<CR>", { desc = "Delete current buffer" })

set_keymap("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Nvim-Tree" })
