local util = require(PREFIX .. "utils")

local M = {}

vim.g.autoformat = true

function M.toggle(bufnr)
    local enable = M.enabled(bufnr)
    if enable == nil then
        enable = true
    end
    enable = not enable
    if bufnr then
        vim.b.autoformat = enable
    else
        vim.g.autoformat = enable
        vim.b.autoformat = nil
    end
    if enable then
        Notify("Enable format on save")
    else
        Notify("Disable format on save")
    end
end

function M.enabled(bufnr)
    bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
    local gaf = vim.g.autoformat
    local baf = vim.b[bufnr].autoformat

    -- If the buffer has a local value, use that
    if baf ~= nil then
        return baf
    end

    -- Otherwise use the global value if set, or true by default
    return gaf
end

function M.format()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.g.autoformat == false and vim.b.autoformat == false then
        return
    end

    -- local filetype = vim.bo[bufnr].filetype
    -- local METHOD = require("null-ls").methods.FORMATTING
    -- local have_nls = #require("null-ls.sources").get_available(filetype, METHOD) > 0

    vim.lsp.buf.format({
        bufnr = bufnr,
        -- filter = function(client)
        --     if have_nls then
        --         print("null-ls:", client.name)
        --         return client.name == "null-ls"
        --     end

        --     print("normal: ", client.name)
        --     return client.name ~= "null-ls"
        -- end
    })
end

function M.supports_format(client)
    if client.server_capabilities and client.server_capabilities.documentFormattingProvider == false then
        return false
    end

    return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

function M.on_attach(client, bufnr)
    local group = AUGROUP("MyFormatting")
    if M.supports_format(client) then
        -- CLEAR_AUTOCMD({ group = group, buffer = bufnr })
        NNOREMAP("<leader>tf", M.toggle, { desc = "Toggle format on save" })
        AUTOCMD("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
                if M.enabled(bufnr) then
                    M.format()
                end
            end
        })
    end
end

return M
