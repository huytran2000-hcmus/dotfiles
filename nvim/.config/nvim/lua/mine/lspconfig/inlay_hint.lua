local M = {}

function M.on_attach(client, bufnr)
    if not client:supports_method("textDocument/inlayHint") then
        return
    end

    if vim.api.nvim_buf_is_valid(bufnr)
        and vim.bo[bufnr].buftype == ""
    then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    NNOREMAP("<leader>ui", M.toggle, { desc = "Toggle inline hint" })
end

function M.toggle()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end

return M
