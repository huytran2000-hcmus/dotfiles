return {
    -- https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
        -- lualine
        vim.opt.laststatus = 3
    end,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "folke/trouble.nvim",
    },
    opts = function()
        local symbols = require("trouble").statusline({
            mode = "symbols",
            groups = {},
            title = false,
            filter = { range = true },
            format = "{kind_icon}{symbol.name:Normal}",
            hl_group = "lualine_c_normal",
        })

        return {
            options = {
                disabled_filetypes = {
                    statusline = {},
                    winbar = {
                        "dapui_watches",
                        "dapui_stacks",
                        "dapui_breakpoints",
                        "dapui_scopes",
                        "dapui_console",
                        "dap-repl",
                        "NvimTree",
                        "toggleterm",
                        "alpha",
                        "qf",
                        "trouble",
                    },
                },
                globalstatus = true,
                theme = "auto",
                -- component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
            },
            extensions = {
                "nvim-dap-ui",
                "nvim-tree",
                "quickfix",
                "man",
                -- "gitsigns",
                -- "fugitive",
                -- "fzf",
                -- "mundo",
                -- "neo-tree",
                -- "nerdtree",
                -- "symbols-outline",
                "toggleterm",
                "trouble",
            },
            sections = {
                lualine_a = { "mode", "searchcount" },
                lualine_b = {
                    { "branch" },
                    {
                        "diff",
                        symbols = { added = "+", modified = "~", remove = "-" }
                    }
                },
                lualine_c = {
                    {
                        "diagnostics",
                        sources = { "nvim_workspace_diagnostic" },
                    },
                },
                lualine_x = {
                    {
                        symbols.get,
                        cond = symbols.has,
                    },
                },
                lualine_y = {
                    function()
                        return require("auto-session.lib").current_session_name(true)
                    end,
                },
                lualine_z = { "%S" },
            },
            winbar = {
                lualine_a = {
                    {
                        "buffers",
                        mode = 0,
                        max_length = vim.o.columns * 3 / 4, -- Maximum width of buffers component,
                        symbols = {
                            modified = "[+]", -- Text to show when the buffer is modified
                            alternate_file = "#", -- Text to show to identify the alternate file
                            directory = "", -- Text to show when the buffer is a directory
                        },
                        -- filetype_names = {
                        --     TelescopePrompt = 'Telescope',
                        --     dashboard = 'Dashboard',
                        --     packer = 'Packer',
                        --     fzf = 'FZF',
                        --     alpha = 'Alpha'
                        -- },
                    }
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_z = {
                    {
                        "filename",
                        file_status = true,
                        newfile_status = true,
                    },
                },
            },
            tabline = {
                lualine_a = {},
                lualine_b = {
                    {
                        "tabs",
                        mode = 2,
                    },
                },
            },
        }
    end,
}
