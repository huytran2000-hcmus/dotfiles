local util = require(PREFIX .. "utils")

local M = {}

M.autoformat = true

function M.toggle()
    if vim.b.autoformat == false then
        vim.b.autoformat = nil
        M.autoformat = true
    else
        M.autoformat = not M.autoformat
    end

    if M.autoformat then
        util.notify("Enable format on save")
    else
        util.notify("Disable format on save")
    end
end

function M.format()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.b.autoformat == false then
        return
    end

    local filetype = vim.bo[bufnr].filetype
    local METHOD = require("null-ls").methods.FORMATTING
    local have_nls = #require("null-ls.sources").get_available(filetype, METHOD) > 0

    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client)
            if have_nls then
                return client.name == "null-ls"
            end

            return client.name ~= "null-ls"
        end
    })
end

function M.on_attach(client, bufnr)
    if client.config and client.config.capabilities and client.config.capabilities.documentFormattingProvider == false then
        return
    end

    local group = AUGROUP("MyFormatting")
    --if client.supports_method("textDocument/formatting") then
    if client.supports_method("textDocument/formatting") then
        CLEAR_AUTOCMD({ group = group, buffer = bufnr })
        NNOREMAP("<leader>tf", M.toggle, { desc = "Toggle format on save" })
        AUTOCMD("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
                if M.autoformat then
                    M.format()
                end
            end
        })
    end
end

return M
