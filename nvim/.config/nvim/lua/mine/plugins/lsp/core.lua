return {
    {
        -- https://github.com/neovim/nvim-lspconfig
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                -- LSP manager
                "williamboman/mason.nvim",
                cmd = "Mason",
                dependencies = {
                    "williamboman/mason-lspconfig.nvim",
                }
            },
            {
                "hrsh7th/cmp-nvim-lsp",
                dependencies = "hrsh7th/cmp-nvim-lsp-signature-help",
            },
            {
                "folke/neodev.nvim",
            },
        },
        config = function()
            local cfg = require(PREFIX .. "lspconfig")
            local servers = cfg.servers
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            )
            local setup = function(server)
                local server_opts = servers[server] or {}
                server_opts = vim.tbl_deep_extend("force", {
                    on_attach = cfg.on_attach,
                    capabilities = vim.deepcopy(capabilities)
                }, server_opts)

                if cfg.setup[server] then
                    if cfg.setup[server](server, server_opts) then
                        return
                    end
                elseif cfg.setup["*"] then
                    if cfg.setup["*"](server, server_opts) then
                        return
                    end
                end

                require("lspconfig")[server].setup(server_opts)
            end

            local mlsp = require("mason-lspconfig")
            local available_server = mlsp.get_available_servers()
            local ensure_installed = {} ---@type string[]
            for server, _ in pairs(servers) do
                if not vim.tbl_contains(available_server, server) then
                    setup(server)
                end
                ensure_installed[#ensure_installed + 1] = server
            end

            require("neodev").setup()
            require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
            require("mason-lspconfig").setup_handlers({ setup })
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {}, -- This is needed for append to
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local registry = require("mason-registry")
            local ensure_installed = function()
                for _, pkg in ipairs(opts.ensure_installed) do
                    if not registry.is_installed(pkg) then
                        local p = registry.get_package(pkg)
                        p:install()
                    end
                end
            end
            registry.refresh(ensure_installed)
        end,
    },
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
    },
}
