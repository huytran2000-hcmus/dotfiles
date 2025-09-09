vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "rounded",
    }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signatureHelp, {
        border = "rounded",
    }
)
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

return {
    servers = {
        gopls = require(PREFIX .. "lspconfig.servers.gopls"),
        lua_ls = require(PREFIX .. "lspconfig.servers.lua_ls"),
        jsonls = require(PREFIX .. "lspconfig.servers.jsonls"),
    },
    

    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    --@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
    },
}
