return {
    diagnostic = {
        virtual_text = { spacing = 4, prefix = "●" },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
        },
    },
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
