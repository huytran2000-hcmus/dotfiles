local M = {}

function M.on_attach(client, bufnr)
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = bufnr })
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
