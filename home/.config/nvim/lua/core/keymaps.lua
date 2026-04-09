---@param desc string
local function opts(desc)
  return { desc = desc, noremap = true, silent = true }
end

-- Put in Visual Mode should not replace register
vim.keymap.set("x", "p", "pgvy")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlights"))

vim.keymap.set("c", "<Esc>", "<C-c>")

-- Move lines with alt + jk
vim.keymap.set("n", "<A-j>", "<cmd>m+<CR>==", opts("Move current line down"))
vim.keymap.set("n", "<A-k>", "<cmd>m-2<CR>==", opts("Move current line up"))
vim.keymap.set("i", "<A-j>", "<Esc><cmd>m+<CR>==gi", opts("Move current line down"))
vim.keymap.set("i", "<A-k>", "<Esc><cmd>m-2<CR>==gi", opts("Move current line up"))
-- TODO: possible to use <cmd> instead?
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts("Move selected line(s) down"))
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts("Move selected line(s) up"))

-- Indentation
vim.keymap.set("n", "<Tab><Tab>", ">>", opts("Indent current line"))
vim.keymap.set("n", "<S-Tab><S-Tab>", "<<", opts("Unindent current line"))

vim.keymap.set("v", ">", ">gv", opts("Indent selected line(s)"))
vim.keymap.set("v", "<", "<gv", opts("Unindent selected line(s)"))
vim.keymap.set("v", "<Tab>", ">gv", opts("Indent selected line(s)"))
vim.keymap.set("v", "<S-Tab>", "<gv", opts("Unindent selected line(s)"))

-- Buffer navigation
-- navigate splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

local function copy_location()
  local path = vim.fn.expand("%")
  local location
  local mode = vim.fn.mode()

  local is_visual = mode == "v" or mode == "V" or mode == "\22" -- \22 = <C-v> (visual block)
  if is_visual then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    location = start_line == end_line and path .. ":" .. start_line or path .. ":" .. start_line .. "-" .. end_line
  else
    location = path .. ":" .. vim.fn.line(".")
  end

  vim.fn.setreg("+", location)
  vim.notify("Copied: " .. location)

  if is_visual then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end

vim.keymap.set({ "n", "x" }, "<leader>yp", copy_location, opts("Copy file location"))
