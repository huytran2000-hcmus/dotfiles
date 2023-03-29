local function rename_current_file()
    local buf = vim.api.nvim_get_current_buf()
    if vim.fn.getbufvar(buf, "&mod") == 1 then
        print(vim.fn.getbufvar(buf, "&mod"))
        print('Save your file and retry')
        return
    end

    local old_name = vim.fn.expand('%')
    local new_name
    vim.ui.input({prompt = 'New file name: ', completetion = "file"}, function(input)
        new_name = vim.fn.expand(input)
    end)

    if new_name ~= "v:null" and new_name ~= '' and new_name ~= old_name then
        vim.cmd("saveas "..new_name)
        vim.cmd("silent !rm "..old_name)
        vim.cmd("bd ".. old_name)
        vim.cmd("redraw!")
    end
end

CMD("Rename", rename_current_file, {
    nargs = 0,
    desc = "Rename the current buffer's file name",
})
local function empty_registers() local registers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"
    for i = 1, #registers do
        vim.fn.setreg(registers:sub(i, i), "")
    end
end

CMD("WipeReg", empty_registers, {
    nargs = 0,
    desc = "Empty most of registers",
})
