local M = {}

function M.on_attach(client, bufnr)
    if not client.supports_method("textDocument/inlayHint") then
        return
    end
    vim.api.nvim_create_autocmd({ "LspAttach", "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
    })
end

return M
