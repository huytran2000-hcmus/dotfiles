local M = {}

function M.on_attach(client, bufnr)
    vim.api.nvim_create_autocmd({ "LspAttach", "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
    })
end

return M
