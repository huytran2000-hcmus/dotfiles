local M = {}

function M.on_attach(client, bufnr)
    if not client.supports_method("textDocument/inlayHint") then
        return
    end

    if vim.api.nvim_buf_is_valid(bufnr)
        and vim.bo[bufnr].buftype == ""
    then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    local group = AUGROUP("MyInlineHint")
    CLEAR_AUTOCMD({ group = group, buffer = bufnr })
    NNOREMAP("<leader>ti", M.toggle, { desc = "Toggle inline hint" })
    AUTOCMD("BufWritePre", {
        group = group,
        buffer = bufnr,
        callback = function()
            M.toggle(bufnr)
        end
    })
end

function M.toggle(bufnr)
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = bufnr })
end

return M
