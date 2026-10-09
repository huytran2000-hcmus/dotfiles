-- AST for better syntax: highlight
-- nvim-treesitter `main` branch: only installs parsers/queries. Highlighting,
-- folding and incremental selection (visual `an` / `in`) are built into Neovim 0.12.
-- Parsers are compiled with the `tree-sitter` CLI (installed by install.sh).
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    dependencies = { "LiadOz/nvim-dap-repl-highlights" },
    init = function()
        vim.o.foldmethod = 'expr'
        vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.o.foldenable = false
    end,
    -- Language specs add parsers via { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { ... } } }
    opts_extend = { "ensure_installed" },
    opts = {
        ensure_installed = {
            "lua",
            "ruby",
            "vimdoc",
            "vim",
            "python",
            "javascript",
            "sql",
            "dap_repl", -- registered by nvim-dap-repl-highlights.setup() below
        },
    },
    config = function(_, opts)
        -- Must run before install() so the dap_repl parser is known to nvim-treesitter
        require("nvim-dap-repl-highlights").setup()
        require("nvim-treesitter").install(opts.ensure_installed)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("mine_treesitter_start", { clear = true }),
            callback = function(args)
                -- Start highlighting when a parser exists for this filetype; ignore otherwise
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end
}
