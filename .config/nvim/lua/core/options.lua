-- Set leader
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.breakindent = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"

vim.opt.linebreak = true

-- Cursor
vim.opt.cursorline = true
vim.opt.scrolloff = 1

-- Enable mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"

-- True colors
vim.opt.termguicolors = true

vim.opt.hidden = true

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Split position
vim.opt.splitbelow = true
vim.opt.splitright = true

-- File encoding
vim.opt.fileencoding = "utf-8"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Command timeout
vim.opt.timeoutlen = 300

-- Status line
vim.opt.laststatus = 3
vim.opt.showmode = false

vim.opt.iskeyword:append("-")
