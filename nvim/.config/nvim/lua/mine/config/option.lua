vim.g.mapleader = " "

vim.cmd("syntax on")

vim.cmd [[set path+=~/.config/nvim/**]]
vim.cmd [[set path^=**]]

vim.opt.clipboard:append("unnamedplus")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true

vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

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

vim.opt.cmdheight = 0
vim.opt.showcmdloc = "statusline"

vim.opt.showmode = false

vim.opt.autowriteall = true

vim.filetype.add({
    extension = {
        gohtml = "html",
    }
})

vim.opt.undofile = true
-- vim.opt.undolevels = 1000
vim.opt.shada = "!,'100,f1,<100,s50,h"

vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
        ["+"] = 'clip.exe',
        ["*"] = 'clip.exe',
    },
    paste = {
        ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
}

local function setup_wsl2_clipboard()
    -- Check if we're in WSL
    local is_wsl = vim.fn.has('wsl') == 1 or
        (vim.fn.exists('$WSL_DISTRO_NAME') == 1) or
        (vim.fn.filereadable('/proc/sys/fs/binfmt_misc/WSLInterop') == 1)

    if is_wsl then
        -- WSL2 clipboard using win32yank
        vim.g.clipboard = {
            name = 'WslClipboard',
            copy = {
                ["+"] = 'clip.exe',
                ["*"] = 'clip.exe',
            },
            paste = {
                ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
        }
    end
end

setup_wsl2_clipboard()
