return {
    {
        "tpope/vim-dadbod",
        dependencies = {
            "kristijanhusak/vim-dadbod-ui",
            "kristijanhusak/vim-dadbod-completion"
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
        end,
        keys = {
            { "<leader>ou", ":DBUIToggle<CR>",        desc = "Toggle Dadbod UI" },
            { "<leader>of", ":DBUIFindBuffer<CR>",    desc = "Find Dadbod buffer" },
            { "<leader>or", ":DBUIRenameBuffer<CR>",  desc = "Rename Dadbod buffr" },
            { "<leader>ol", ":DBUILastQueryInfo<CR>", desc = "Get last Dadbod query info" },
        },
        config = function()
            vim.g.db_ui_save_location = "~/.local/state/nvim/vim-dadbod"
            vim.g.db_ui_execute_on_save = 0
            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_table_helpers = {
                postgresql = {
                    Count = 'SELECT COUNT(*) from "{table}"'
                }
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "sql",
                },
                command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
            })

            AUTOCMD("FileType", {
                pattern = {
                    "sql",
                    "mysql",
                    "plsql",
                },
                callback = function()
                    require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
                end,
            })

            AUTOCMD("FileType", {
                pattern = {
                    "sql",
                    "mysql",
                    "plsql",
                },
                callback = function()
                    NNOREMAP("<C-x>", "<Plug>(DBUI_ExecuteQuery)")
                end
            })
        end
    }
}
