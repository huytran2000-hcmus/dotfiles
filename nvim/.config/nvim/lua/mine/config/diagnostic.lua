local icons = require(PREFIX .. "config").icons.diagnostic
local severity = vim.diagnostic.severity

vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●", source = "if_many" },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
    },
    signs = {
        text = {
            [severity.ERROR] = icons.DiagnosticSignError,
            [severity.WARN] = icons.DiagnosticSignWarn,
            [severity.HINT] = icons.DiagnosticSignHint,
            [severity.INFO] = icons.DiagnosticSignInfo,
        },
        numhl = {
            [severity.ERROR] = "DiagnosticSignError",
            [severity.WARN] = "DiagnosticSignWarn",
            [severity.HINT] = "DiagnosticSignHint",
            [severity.INFO] = "DiagnosticSignInfo",
        },
    },
})
