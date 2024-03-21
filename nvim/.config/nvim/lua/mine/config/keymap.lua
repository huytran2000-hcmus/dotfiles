-- Better up and down
-- NNOREMAP("j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
-- NNOREMAP("k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Move between window
NNOREMAP("<C-h>", "<C-w>h", { desc = "Go to left window" })
NNOREMAP("<C-l>", "<C-w>l", { desc = "Go to right window" })
NNOREMAP("<C-k>", "<C-w>k", { desc = "Go to upper window" })
NNOREMAP("<C-j>", "<C-w>j", { desc = "Go to lower window" })
NNOREMAP("<Leader>ww", "<C-w>w", { desc = "Go to other window" })
NNOREMAP("<Leader>wp", "<C-w>p", { desc = "Go to previous windows" })
NNOREMAP("<Leader>wd", "<C-w>c", { desc = "Close current window" })
NNOREMAP("<Leader>wo", "<C-w>o", { desc = "Close other windows" })

-- Resize window
NNOREMAP("<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
NNOREMAP("<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
NNOREMAP("<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
NNOREMAP("<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move line around
VNOREMAP("J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines below" })
VNOREMAP("U", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Buffer
NNOREMAP("]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
NNOREMAP("[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
NNOREMAP("<leader>bb", "<C-w>o", { desc = "Close all other buffer" })

-- Move between tab
NNOREMAP("]t", "<cmd>tabnext<CR>", { desc = "Next tab" })
NNOREMAP("[t", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
NNOREMAP("<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
NNOREMAP("<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })

-- Center screen scroll
NNOREMAP("<C-d>", "<C-d>zz", { desc = "Center screen scroll down" })
NNOREMAP("<C-u>", "<C-u>zz", { desc = "Center screen scroll up" })

-- Quickfix
NNOREMAP("]q", ":cnext<CR>", { desc = "Move to next qf entry" })
NNOREMAP("[q", ":cprev<CR>", { desc = "Move to previous qf entry" })
NNOREMAP("<leader>qd", ":cclo<CR>", { desc = "Close quickfix list" })

-- Miscellaneous
NNOREMAP("<Esc>", "<cmd>nohls<CR><Esc>", { desc = "Clear search and escape" })
NNOREMAP("Q", "q", { desc = "Remap macro" })
NNOREMAP("q", "<nop>", { desc = "Unset q" })
TNOREMAP("<Esc>", "<C-\\><C-n>")
NNOREMAP("<leader>cp", ":let @*=expand('%:p')<CR>", {
    desc = "Copy current file path",
    silent = true,
})

-- Diagnostic
NNOREMAP("<leader>k", vim.diagnostic.open_float, { desc = "Open line diagnostic" })
NNOREMAP("[d", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
NNOREMAP("]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
NNOREMAP("<leader>qf", function() vim.diagnostic.setqflist() end)
