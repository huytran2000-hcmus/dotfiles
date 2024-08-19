return {
    -- cmd = {"gopls"},
    -- filetypes = {"go", "gomod", "gowork", "gotmpl"},
    -- root_dir = function()
    --     require("lspconfig.util").root_pattern("go.work", "go.mod", ".git")
    -- end,
    -- single_file_support = true,
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
            usePlaceholders = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
            templateExtensions = { "tmpl" },
            gofumpt = true
        },
    },
}
