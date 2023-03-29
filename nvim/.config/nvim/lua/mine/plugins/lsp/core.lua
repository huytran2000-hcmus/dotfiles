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
                cond = function()
                    return require(PREFIX .. "utils").has("nvim-cmp")
                end
            },
            {
                "folke/neodev.nvim",
            },
        },
        config = function()
            local cfg = require(PREFIX .. "lspconfig")
            for name, text in pairs(require(PREFIX .. "config").icons.diagnostic) do
                vim.fn.sign_define(name, {
                    texthl = name,
                    text = text,
                    numhl = name
                })
            end
            vim.diagnostic.config(cfg.diagnostic)

            local servers = cfg.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            local core_on_attach = require(PREFIX .. "lspconfig.core").on_attach
            local format_on_attach = require(PREFIX .. "lspconfig.format").on_attach
            local setup = function(server)
                local server_opts = servers[server] or {}
                server_opts = vim.tbl_deep_extend("force", {
                    on_attach = function(client, bufnr)
                        core_on_attach(client, bufnr)
                        format_on_attach(client, bufnr)
                    end,
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

            -- Temperal fix
            local mappings = require("mason-lspconfig.mappings.server")
            if not mappings.lspconfig_to_package.lua_ls then
                mappings.lspconfig_to_package.lua_ls = "lua-language-server"
                mappings.package_to_lspconfig["lua-language-server"] = "lua_ls"
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
        cmd = "Mason",
        opts = {
            ensure_installed = {
                -- "stylua",
                -- "shfmt",
                -- "flake8",
                "gofumpt",
                "golangci-lint"
            },
            setting = {}
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end,
    },
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
    },
}
