local yank_group = AUGROUP("MyYank")
AUTOCMD("TextYankPost", {
    group = yank_group,
    callback = function() vim.highlight.on_yank() end,
    desc = "Briefly highlight the selected text"
})

local help_group = AUGROUP("MyHelp")
AUTOCMD("BufWinEnter", {
    pattern = "quickfix",
    group = help_group,
    callback = function()
        if vim.fn.getloclist(0, { title = 0 }).title == "Help TOC" then
            vim.keymap.set({ 'n', 's' }, "<CR>", "<CR>:lclose<CR>", { silent = true })
        end
    end,
    desc = "Choose a entry in help's TOC close it"
})

-- AUTOCMD({ "BufNewFile", "BufReadPost" }, {
--     callback = CDProjectRoot,
--     desc = "Set cwd to current project root"
-- })
