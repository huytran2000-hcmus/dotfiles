-- AST for better syntax: highlight
return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
        opts = {
            playground = {
                enable = true,
                disable = {},
                updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            }
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            AUTOCMD({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
                group = AUGROUP("MyTreeSitter"),
                callback = function()
                    vim.opt.foldmethod = "expr"
                    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
                    vim.opt.foldenable = not vim.opt.foldenable
                end,
                desc = "Workaround for treesitter folding for lua",
            })
        end
    },
    opts = {
        ensure_installed = { "go", "lua", "vimdoc", "vim" },
        sync_install = false,
        auto_install = false, -- Only enable if have treesiter CLI
        ignore_install = {},
        highlight = {
            enable = true,
            disable = {}, -- List of language that will be disable
            additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn", -- set to `false` to disable one of the mappings
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end
}
