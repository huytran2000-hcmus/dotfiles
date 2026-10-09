return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            buildFlags = { "-tags=integration" },
                            analyses = {
                                unusedparams = true,
                                composites = true,
                                bool = true,
                                -- fieldalignment = true,
                                nilness = true,
                                shadow = true,
                                structtag = true,
                                printf = true,
                            },
                            staticcheck = true,
                            codelenses = {
                                gc_details = false,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            -- usePlaceholders = true,
                            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                            semanticTokens = true,
                            templateExtensions = { "tmpl" },
                            gofumpt = false, -- Compatible with team
                        },
                    },
                },
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local builtins = require("null-ls").builtins
            opts.sources = vim.list_extend(opts.sources or {}, {
                builtins.formatting.goimports,
                -- builtins.formatting.goimports_reviser,
                builtins.diagnostics.golangci_lint,
            })
        end,
    },
    {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "goimports", "goimports-reviser", "golangci-lint", "delve" } },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                -- https://github.com/leoluz/nvim-dap-go
                -- Registers the `go` (delve) adapter and configurations; also used by neotest-golang
                "leoluz/nvim-dap-go",
                opts = {},
            },
        },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            {
                -- https://github.com/fredrikaverpil/neotest-golang
                "fredrikaverpil/neotest-golang",
                version = "*",
            },
        },
        opts = { adapters = { ["neotest-golang"] = {} } },
    },
}
