local core_on_attach = require(PREFIX .. "lspconfig.core").on_attach
local format_on_attach = require(PREFIX .. "lspconfig.autoformat").on_attach
local inlay_hint_on_attach = require(PREFIX .. "lspconfig.inlay_hint").on_attach
local codelens_on_attach = require(PREFIX .. "lspconfig.codelens").on_attach
return {
    -- https://github.com/jose-elias-alvarez/null-ls.nvim
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "nvim-lua/plenary.nvim" },
    },
    opts = function()
        local nls = require("null-ls")
        local builtins = nls.builtins
        return {
            -- Must exist in PATH
            sources = {
                builtins.formatting.prettier,
                -- builtins.formatting.fixjson,
                -- builtins.formatting.gofmt,
                builtins.formatting.shfmt,
                builtins.formatting.gofumpt,
                builtins.formatting.goimports_reviser,
                -- builtins.hover.dictionary,
                builtins.diagnostics.golangci_lint,
                builtins.diagnostics.codespell,
                -- builtins.formatting.write_good,
            },
            debounce = 250,
            default_timeout = 5000,
            -- diagnostics_format = "[#{c}] #{m} (#{s})",
            -- cmd = { "nvim" },
            -- fallback_severitty = vim.diagnostic.severity.ERROR,
            -- notify_format = "[null-ls] %s",
            -- root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
        }
    end,
}
