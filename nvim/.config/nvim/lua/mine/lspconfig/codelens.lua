local M = {}

function M.on_attach(client, bufnr)
    if not client:supports_method("textDocument/codeLens") then
        return
    end
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
end

return M
