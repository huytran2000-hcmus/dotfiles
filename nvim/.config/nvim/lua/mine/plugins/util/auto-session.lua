local function count_modified_buffers()
    local count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
            count = count + 1
        end
    end
    return count
end

return {
    "rmagatti/auto-session",
    lazy = false,
    init = function()
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {
        suppressed_dirs = { "~/", "~/Downloads" },
        bypass_save_filetypes = { "alpha" },
        close_filetypes_on_save = { "toggleterm", "checkhealth", "lazygit", "NvimTree" },
        log_level = "error",
        cwd_change_handling = true,
        lsp_stop_on_restore = true,
        pre_restore_cmds = {
            function()
                local modified = count_modified_buffers()
                if modified > 0 then
                    vim.notify(
                        modified .. " unsaved buffer(s), save them first",
                        vim.log.levels.WARN
                    )
                    return false
                end
            end,
        },
        no_restore_cmds = {
            -- Runs when the cwd changed to a dir without a session. Only clean up
            -- when the change came from the worktree picker, so a manual `:cd`
            -- keeps the open buffers.
            function(is_startup)
                local reopen = vim.g.worktree_reopen_file
                local switching = vim.g.worktree_switching
                vim.g.worktree_switching = nil
                vim.g.worktree_reopen_file = nil
                if is_startup ~= false or not switching then
                    return
                end

                local modified = count_modified_buffers()
                if modified > 0 then
                    vim.notify(
                        modified .. " unsaved buffer(s), keeping old buffers open",
                        vim.log.levels.WARN
                    )
                    return
                end

                for _, client in ipairs(vim.lsp.get_clients()) do
                    client:stop()
                end
                vim.cmd("silent! %bwipeout!")
                vim.cmd("clearjumps")

                if reopen and vim.fn.filereadable(reopen) == 1 then
                    vim.cmd.edit(vim.fn.fnameescape(reopen))
                end
            end,
        },
    },
}
