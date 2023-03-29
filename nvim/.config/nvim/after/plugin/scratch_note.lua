local fname =  vim.fn.escape("[__Note__]", "[]")
local created = false
local function create_scratch_note()
    if not created then
        vim.cmd(string.format("new %s", fname))
        vim.cmd("echom 'Scratch note created'")
        created = true
        return
    end

    vim.cmd(string.format("buffer %s", fname))
end

local function mark_scratch_note()
    vim.cmd("setlocal buftype=nofile")
    vim.cmd("setlocal bufhidden=hide")
    vim.cmd("setlocal nobuflisted")
    vim.cmd("setlocal noswapfile")
end


local group = vim.api.nvim_create_augroup("MyScratchNote", {clear = true})
vim.api.nvim_create_autocmd({"BufNewFile"}, {
    group = group,
    pattern = fname,
    callback = function()
        mark_scratch_note()
    end
})

vim.api.nvim_create_user_command("Note", create_scratch_note, {
    nargs = 0,
    desc = "Create or switch to scratch note"
})

