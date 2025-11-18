return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
        signs                        = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '_', show_count = true },
            topdelete    = { text = '‾', show_count = true },
            changedelete = { text = '󱣳', show_count = true },
            untracked    = { text = '┆' },
        },
        signs_staged                 = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '_', show_count = true },
            topdelete    = { text = '‾', show_count = true },
            changedelete = { text = '󱣳', show_count = true },
            untracked    = { text = '┆' },
        },
        signs_staged_enable          = true,
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
            follow_files = true,
        },
        auto_attach                  = true,
        attach_to_untracked          = true,
        current_line_blame           = true,
        current_line_blame_opts      = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 500,
            ignore_whitespace = false,
            use_focus = true,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil, -- Use default
        max_file_length              = 10000,
        preview_config               = {
            -- Options passed to nvim_open_win
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },
        on_attach                    = function(bufnr)
            local gitsigns = require('gitsigns')
            NNOREMAP("]c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gitsigns.nav_hunk('next')
                end
            end, { desc = "Gitsigns: Next hunk" })

            NNOREMAP("[c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gitsigns.nav_hunk('prev')
                end
            end, { desc = "Gitsigns: Previous hunk" })

            NNOREMAP('<leader>hs', gitsigns.stage_hunk, { desc = "Gitsigns: Stage/Unstage hunk" })
            NNOREMAP('<leader>hr', gitsigns.reset_hunk, { desc = "Gitsigns: Reset hunk" })

            NNOREMAP('<leader>hls', function()
                local cur_line = vim.api.nvim_win_get_cursor(0)[1]
                gitsigns.stage_hunk({ cur_line, cur_line })
            end, { desc = "Gitsigns: Stage/Unstage current line" })
            NNOREMAP('<leader>hlr', function()
                local cur_line = vim.api.nvim_win_get_cursor(0)[1]
                gitsigns.reset_hunk({ cur_line, cur_line })
            end, { desc = "Gitsigns: Reset current line" })

            NNOREMAP('<leader>hh', function()
                    gitsigns.select_hunk()
                end,
                { desc = "Gitsigns: Select hunk" })


            NNOREMAP('<leader>hp', gitsigns.preview_hunk, { desc = "Gitsigns: Preview hunk" })
            NNOREMAP('<leader>hi', gitsigns.preview_hunk_inline, { desc = "Gitsigns: Inline preview hunk" })

            NNOREMAP('<leader>hS', gitsigns.stage_buffer, { desc = "Gitsigns: Stage buffer" })
            NNOREMAP('<leader>hR', gitsigns.reset_buffer, { desc = "Gitsigns: Reset buffer" })

            NNOREMAP('<leader>hb', function() gitsigns.blame_line { full = true } end,
                { desc = "Gitsigns: Blame current line" })

            NNOREMAP('<leader>hd', gitsigns.diffthis, { desc = "Gitsigns: Diff this blame" })
            NNOREMAP('<leader>hD', function() gitsigns.diffthis('@') end,
                { desc = "Gitsigns: Diff blame against its parent commit" })
        end
    }
}
