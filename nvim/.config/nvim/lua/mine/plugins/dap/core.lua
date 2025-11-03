return {
    {
        -- https://github.com/mfussenegger/nvim-dap
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>db",  function() require("dap").continue() end,                                 desc = "Debug: Continue" },
            { "<leader>dn",  function() require("dap").step_over() end,                                desc = "Debug: Step Over" },
            { "<leader>di",  function() require("dap").step_into() end,                                desc = "Debug: Step Into" },
            { "<leader>do",  function() require("dap").step_out() end,                                 desc = "Debug: Step Out" },
            { "<leader>dr",  function() require("dap").repl.open() end,                                desc = "Debug: REPL" },
            { "<leader>dg",  function() require("dap").goto_() end,                                    desc = "Debug: Go to" },
            { "<leader>dt",  function() require("dap").terminate() end,                                desc = "Debug: Terminate" },
            { "<leader>dl",  function() require("dap").run_last() end,                                 desc = "Debug: Continue" },
            { "<leader>de",  function() require("dapui").eval() end,                                   desc = "Debug: Hover" },
            { "<leader>dui", function() require("dapui").toggle() end,                                 desc = "Debug: Toggle UI" },
            { "<space>bp",   function() require("persistent-breakpoints.api").toggle_breakpoint() end, desc = "Toggle Breadpoint" },
            { "<space>B",    function() require("dap").clear_breakpoints() end,                        desc = "Clear Breakpoint" }
        },
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = {
                    "nvim-neotest/nvim-nio",
                    {
                        "rcarriga/cmp-dap",
                        config = function()
                            require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                                sources = {
                                    { name = "dap" },
                                },
                            })
                        end
                    },
                    {
                        "mason.nvim",
                    },
                    {
                        "LiadOz/nvim-dap-repl-highlights",
                    },
                },
                opts = {
                    controls = {
                        element = "console"
                    },
                    expand_lines = true,
                    force_buffers = true,
                    layouts = {
                        {
                            elements = {
                                -- { id = "console", size = 0.5 },
                                { id = "repl", size = 1 },
                            },
                            size = 10,
                            position = "bottom"
                        },
                        {
                            elements = {
                                { id = "breakpoints", size = 0.25 },
                                { id = "watches",     size = 0.25 },
                                { id = "scopes",      size = 0.25 }
                            },
                            size = 40,
                            position = "left"
                        },

                    },
                    mappings = {
                        edit = "e",
                        expand = { "<CR>" },
                        open = "o",
                        remove = "d",
                        repl = "r",
                        toggle = "t"
                    },
                },
            },
            {
                'Weissle/persistent-breakpoints.nvim',
                opts = {
                    save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
                    load_breakpoints_event = nil,
                    always_reload = true,
                }
            }
        },
        config = function()
            local dap = require("dap")
            local cfg = require(PREFIX .. "dapconfig")
            -- Adapters configuration
            for adpt, config in pairs(cfg.adapters) do
                dap.adapters[adpt] = config
            end

            -- Debuggee configuration
            for filetype, ft_cfg in pairs(cfg.debugees) do
                dap.configurations[filetype] = ft_cfg
            end

            for name, config in pairs(cfg.signs) do
                vim.fn.sign_define(name, config)
            end

            require('persistent-breakpoints').setup()
            require('persistent-breakpoints.api').load_breakpoints()

            -- dap-ui configuration
            local dapui = require("dapui")
            dap.listeners.after.event_initialized.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
}
