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
        {
            "SmiteshP/nvim-navic",
            config = function()
                local icons = require(PREFIX .. "config").icons.lsp_symbol
                local navic = require("nvim-navic")
                navic.setup {
                    icons = icons
                }
                AUTOCMD("LspAttach", {
                    desc = "Attach nvim-navic to Lsp",
                    callback = function(args)
                        local bufnr = args.buf
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        if client.server_capabilities.documentSymbolProvider then
                            navic.attach(client, bufnr)
                        end
                    end
                })
            end
        }
    },
    opts = {
        options = {
            disabled_filetypes = {
                statusline = {},
                winbar = {
                    "dapui_watches",
                    "dapui_stacks",
                    "dapui_breakpoints",
                    "dapui_scopes",
                    "NvimTree",
                    "toggleterm",
                    "alpha",
                },
            },
            globalstatus = true,
            theme = "auto",
            -- component_separators = { left = '', right = '' },
            -- section_separators = { left = '', right = '' },
        },
        extensions = {
            "nvim-dap-ui",
            "nvim-tree",
            "quickfix",
            "man",
            -- "gitsigns",
            "aerial",
            -- "fugitive",
            -- "fzf",
            -- "mundo",
            -- "neo-tree",
            -- "nerdtree",
            -- "symbols-outline",
            "toggleterm",
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },
            lualine_c = {
                {
                    "diagnostics",
                    sources = { "nvim_workspace_diagnostic" },
                },
            },
            lualine_x = {
                function()
                    local navic = require("nvim-navic")
                    local context = navic.get_location()
                    if context ~= "" then
                        return context
                    end

                    return ""
                end

            },
            lualine_y = {},
            lualine_z = { "progress" }
        },
        winbar = {
            lualine_a = {
                {
                    "buffers",
                    mode = 0,
                    max_length = vim.o.columns * 3 / 4, -- Maximum width of buffers component,
                    symbols = {
                        modified = "[+]",               -- Text to show when the buffer is modified
                        alternate_file = "#",           -- Text to show to identify the alternate file
                        directory = "",              -- Text to show when the buffer is a directory
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
            lualine_y = {
                {
                    "filename",
                    file_status = true,
                    newfile_status = true,
                },
            },
            lualine_z = {
                {
                    "diff",
                    symbols = { added = "+", modified = "~", remove = "-" }
                }
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
}
