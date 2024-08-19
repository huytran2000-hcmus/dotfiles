local icons = require(PREFIX .. "config").icons.diagnostic
for name, text in pairs(icons) do
    vim.fn.sign_define(name, {
        texthl = name,
        text = text,
        numhl = name
    })
end

vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●", source = "if_many" },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
    },
    -- signs = {
    --     texthl = {
    --         [vim.diagnostic.severity.ERROR] = icons.DiagnosticSignError,
    --         [vim.diagnostic.severity.WARN] = icons.iagnosticSignWarn,
    --         [vim.diagnostic.severity.HINT] = icons.DiagnosticSignHint,
    --         [vim.diagnostic.severity.INFO] = icons.DiagnosticSignInfo,
    --     },
    -- }
})
