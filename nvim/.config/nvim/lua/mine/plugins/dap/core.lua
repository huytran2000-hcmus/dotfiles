function LoadLaunchJSON(path)
    require("dap.ext.vscode").load_launchjs(path, { delve = { "go" } })
end

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
            { "<leader>dd",  function() require("dap").terminate() end,                                desc = "Debug: Terminate" },
            { "<leader>dl",  function() require("dap").run_last() end,                                 desc = "Debug: Continue" },
            { "<leader>de",  function() require("dapui").eval() end,                                   desc = "Debug: Hover" },
            { "<leader>dui", function() require("dapui").toggle() end,                                 desc = "Debug: Toggle UI" },
            { "<leader>bp",  function() require("persistent-breakpoints.api").toggle_breakpoint() end, desc = "Toggle Breadpoint" },
            { "<leader>B",   function() require("dap").clear_breakpoints() end,                        desc = "Clear Breakpoint" },
            { "<leader>dt",  function() require(PREFIX .. "dapconfig.go_test").debug_test() end,       desc = "Run individual test" },
            { "<leader>dlt", function() require(PREFIX .. "dapconfig.go_test").debug_last_test() end,  desc = "Run last individual test" },
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
            },
        },
        opts = {
            signs = {
                ["DapBreakpoint"] = {
                    text = "🔴",
                    texthl = "LspDiagnosticsSignError",
                    linehl = "",
                    numhl = "",
                },
                ["DapBreakpointRejected"] = {
                    text = "",
                    texthl = "LspDiagnosticsSignHint",
                    linehl = "",
                    numhl = "",
                },
                ["DapStopped"] = {
                    text = "",
                    texthl = "LspDiagnosticsSignInformation",
                    linehl = "DiagnosticUnderlineInfo",
                    numhl = "LspDiagnosticsSignInformation",
                },
            },
            adapters = {
                go = {
                    type = 'server',
                    port = '${port}',
                    executable = {
                        command = 'dlv',
                        args = { 'dap', '-l', '127.0.0.1:${port}' },
                    }
                }
            },
            debugees = {
                go = {
                    {
                        type = "go",
                        name = "Debug",
                        request = "launch",
                        program = "${file}",
                        outputMode = "remote",
                    },
                    {
                        type = "go",
                        name = "Debug (go.mod)",
                        request = "launch",
                        program = "./${relativeFileDirname}",
                        outputMode = "remote",
                    },
                    {
                        type = "go",
                        name = "Debug test", -- configuration for debugging test files
                        request = "launch",
                        mode = "test",
                        program = "${file}",
                        outputMode = "remote",
                    },
                    -- works with go.mod packages and sub packages
                    {
                        type = "go",
                        name = "Debug test (go.mod)",
                        request = "launch",
                        mode = "test",
                        program = "./${relativeFileDirname}",
                        outputMode = "remote",
                    }
                }
            }
        },
        config = function(_, opts)
            local dap = require("dap")
            -- Adapters configuration
            for adpt, config in pairs(opts.adapters) do
                dap.adapters[adpt] = config
            end

            -- Debuggee configuration
            for filetype, ft_cfg in pairs(opts.debugees) do
                dap.configurations[filetype] = ft_cfg
            end

            for name, config in pairs(opts.signs) do
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

            CMD("LoadLaunchJSON", function(opts)
                LoadLaunchJSON(opts.args)
            end, {
                nargs = 1,
                desc = "Load launch.json for dap.nvim"
            })

            CMD("LoadVSCodeLaunchJSON", function()
                LoadLaunchJSON(".vscode/launch.json")
            end, {
                nargs = 0,
                desc = "Load .vscode/launch.json for dap.nvim"
            })
        end,
    },
}
