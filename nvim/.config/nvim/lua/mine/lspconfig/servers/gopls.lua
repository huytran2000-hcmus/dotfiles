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
            -- analyses = {
            --     unusedparams = true,
            -- },
            staticcheck = true,
        },
    },
}
