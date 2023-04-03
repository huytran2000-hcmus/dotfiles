vim.g.mapleader = " "

vim.cmd("syntax on")

vim.cmd [[set path+=~/.config/nvim/**]]
vim.cmd [[set path^=**]]

vim.opt.mouse = nil
vim.opt.clipboard:append("unnamedplus")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true

vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.autoindent = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.scrolloff = 3
vim.opt.sidescroll = 10
vim.opt.textwidth = 120

vim.opt.hidden = true
vim.opt.list = true
