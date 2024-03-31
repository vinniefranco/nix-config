local opt = vim.opt

opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true

-- -- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 300
vim.o.termguicolors = true
