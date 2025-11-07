return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                -- LSP manager
                -- https://github.com/mason-org/mason.nvim
                "mason-org/mason.nvim",
            },
            {
                "mason-org/mason-lspconfig.nvim",
                config = function() end
            },
            {
                "hrsh7th/cmp-nvim-lsp",
                dependencies = "hrsh7th/cmp-nvim-lsp-signature-help",
            },
            {
                "folke/neodev.nvim",
            },
        },
        config = function(_, opts)
            local cfg = require(PREFIX .. "lspconfig")
            local servers = cfg.servers

            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {}
            )


            require("mason").setup()
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local available_servers = have_mason and
                vim.tbl_keys(require("mason-lspconfig").get_mappings().lspconfig_to_package)
            local mason_excludes = {}
            local configure = function(server)
                local server_opts = servers[server] or {}
                server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities)
                }, server_opts)

                local use_mason = vim.tbl_contains(available_servers, server)
                local setup = cfg.setup[server] or cfg.setup['*']
                if setup and cfg.setup[server](server, server_opts) then
                    mason_excludes[#mason_excludes + 1] = server
                else
                    vim.lsp.config(server, server_opts)
                    if not use_mason then
                        vim.lsp.enable(server)
                    end
                end

                return use_mason
            end
            local ensure_installed = vim.tbl_filter(configure, vim.tbl_keys(servers))
            if have_mason then
                mlsp.setup({
                    ensure_installed = ensure_installed,
                    automatic_enable = { exclude = mason_excludes },
                })
            end
            require("neodev").setup()
        end,
    },
    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                "shfmt",
                -- "gofumpt", -- Already include in gopls
                "goimports-reviser",
                "golangci-lint",
                "codespell",
                "delve",
            }
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
