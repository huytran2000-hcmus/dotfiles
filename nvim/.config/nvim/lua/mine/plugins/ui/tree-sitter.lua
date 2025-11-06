-- AST for better syntax: highlight
return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
        vim.o.foldmethod = 'expr'
        vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.o.foldenable = false
    end,
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
        ensure_installed = {
            "go",
            "lua",
            "ruby",
            "vimdoc",
            "vim",
            "python",
            "javascript",
            "sql",
            "gomod",
            "gowork",
            "gosum",
        },
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
                init_selection = "<C-Space>", -- set to `false` to disable one of the mappings
                node_incremental = "<C-Space>",
                scope_incremental = false,
                node_decremental = "<BS>",
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end
}
