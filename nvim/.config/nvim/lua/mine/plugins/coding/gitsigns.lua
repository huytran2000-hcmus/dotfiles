return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs                   = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '_', show_count = true },
            topdelete    = { text = '‾', show_count = true },
            changedelete = { text = '󱣳', show_count = true },
            untracked    = { text = '┆' },
        },
        watch_gitdir            = {
            interval = 1000,
            follow_files = true,
        },
        attach_to_untracked     = true,
        signcolumn              = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                   = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                  = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff               = false, -- Toggle with `:Gitsigns toggle_word_diff`
        current_line_blame      = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 500,
            ignore_whitespace = false,
        },
        max_file_length         = 10000,
        on_attach               = function(bufnr)
            local gs = package.loaded.gitsigns
            NNOREMAP("]c", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
            end, { expr = true })

            NNOREMAP("[c", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
            end, { expr = true })

            NNOREMAP('<leader>hs', gs.stage_hunk, { desc = "Gitsigns: Stage hunk" })
            NNOREMAP('<leader>hr', gs.reset_hunk, { desc = "Gitsigns: Reset hunk" })

            NNOREMAP('<leader>hls', function()
                local cur_line = vim.api.nvim_win_get_cursor(0)[1]
                gs.stage_hunk({ cur_line, cur_line })
            end, { desc = "Gitsigns: Stage current line" })

            NNOREMAP('<leader>hlr', function()
                local cur_line = vim.api.nvim_win_get_cursor(0)[1]
                gs.reset_hunk({ cur_line, cur_line })
            end, { desc = "Gitsigns: Reset current line" })

            NNOREMAP('<leader>hh', function()
                    gs.select_hunk()
                end,
                { desc = "Gitsigns: Select hunk" })

            VNOREMAP('<leader>hs', function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
                { desc = "Gitsigns: Stage visual selected" })

            VNOREMAP('<leader>hr', function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
                { desc = "Stage visual selected" })

            NNOREMAP('<leader>hu', gs.undo_stage_hunk, { desc = "Gitsigns: Unstage hunk" })
            NNOREMAP('<leader>hp', gs.preview_hunk, { desc = "Gitsigns: Preview hunk" })
            NNOREMAP('<leader>hS', gs.stage_buffer, { desc = "Gitsigns: Stage buffer" })
            NNOREMAP('<leader>hR', gs.reset_buffer, { desc = "Gitsigns: Reset buffer" })
            NNOREMAP('<leader>hb', function() gs.blame_line { full = true } end,
                { desc = "Gitsigns: Blame current line" })
            NNOREMAP('<leader>tb', gs.toggle_current_line_blame, { desc = "Gitsigns: Toggle blame current line" })
            NNOREMAP('<leader>hd', gs.diffthis, { desc = "Gitsigns: Diff this blame" })
            NNOREMAP('<leader>hD', function() gs.diffthis('@') end,
                { desc = "Gitsigns: Diff blame against its parent commit" })
            NNOREMAP('<leader>td', gs.toggle_deleted, { desc = "Gitsigns: Toogle deleted" })
        end
    }
}
