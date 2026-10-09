-- Rounded borders for LSP hover/signature only (global 'winborder' would also hit plugin floats)
for _, name in ipairs({ "hover", "signature_help" }) do
    local orig = vim.lsp.buf[name]
    vim.lsp.buf[name] = function(opts)
        return orig(vim.tbl_extend("keep", opts or {}, { border = "rounded" }))
    end
end
local on_attachs = {}
on_attachs[#on_attachs + 1] = require(PREFIX .. "lspconfig.core").on_attach
on_attachs[#on_attachs + 1] = require(PREFIX .. "lspconfig.autoformat").on_attach
on_attachs[#on_attachs + 1] = require(PREFIX .. "lspconfig.inlay_hint").on_attach
on_attachs[#on_attachs + 1] = require(PREFIX .. "lspconfig.codelens").on_attach


vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buffer = args.buf

        if not client then
            return
        end

        for _, on_attach in ipairs(on_attachs) do
            on_attach(client, buffer)
        end
    end,
})
