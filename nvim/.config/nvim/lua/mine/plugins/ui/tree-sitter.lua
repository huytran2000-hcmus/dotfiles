-- AST for better syntax: highlight
-- nvim-treesitter `main` branch: only installs parsers/queries. Highlighting,
-- folding and incremental selection (visual `an` / `in`) are built into Neovim 0.12.
-- Parsers are compiled with the `tree-sitter` CLI (installed by install.sh).
local parsers = {
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
    "java",
    "dap_repl", -- registered by nvim-dap-repl-highlights.setup() below
}

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
    config = function()
        -- Must run before install() so the dap_repl parser is known to nvim-treesitter
        require("nvim-dap-repl-highlights").setup()
        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("mine_treesitter_start", { clear = true }),
            callback = function(args)
                -- Start highlighting when a parser exists for this filetype; ignore otherwise
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end
}
