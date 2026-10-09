local core_on_attach = require(PREFIX .. "lspconfig.core").on_attach
local format_on_attach = require(PREFIX .. "lspconfig.autoformat").on_attach
local inlay_hint_on_attach = require(PREFIX .. "lspconfig.inlay_hint").on_attach
local codelens_on_attach = require(PREFIX .. "lspconfig.codelens").on_attach
return {
    {
        -- https://github.com/jose-elias-alvarez/null-ls.nvim
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        -- Language specs add sources with their own opts function:
        -- opts = function(_, opts) opts.sources = vim.list_extend(opts.sources or {}, { ... }) end
        opts = function(_, opts)
            local builtins = require("null-ls").builtins
            -- Must exist in PATH
            opts.sources = vim.list_extend(opts.sources or {}, {
                -- builtins.formatting.prettier,
                -- builtins.formatting.fixjson,
                builtins.formatting.shfmt,
                -- builtins.hover.dictionary,
                -- builtins.diagnostics.codespell,
                builtins.completion.spell,
                -- builtins.formatting.write_good,
            })
            opts.debounce = 250
            opts.default_timeout = 5000
            -- opts.diagnostics_format = "[#{c}] #{m} (#{s})"
            -- opts.root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git")
        end,
    },
    {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "shfmt", "codespell" } },
    },
}
