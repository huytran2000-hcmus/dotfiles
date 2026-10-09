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
        },
        dependencies = {
            {
                -- https://github.com/leoluz/nvim-dap-go
                -- Registers the `go` (delve) adapter and configurations; also used by neotest-golang
                "leoluz/nvim-dap-go",
                opts = {},
            },
            {
                "rcarriga/nvim-dap-ui",
                dependencies = {
                    "nvim-neotest/nvim-nio",
                    {
                        "mason.nvim",
                    },
                },
                opts = {
                    controls = {
                        element = "repl"
                    },
                    expand_lines = true,
                    force_buffers = true,
                    layouts = {
                        {
                            elements = {
                                { id = "repl", size = 1 },
                            },
                            size = 15,
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
            adapters = {},
            debugees = {},
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

            require(PREFIX .. "dapconfig.repl_log").setup()

            -- dap-ui configuration
            local dapui = require("dapui")
            dap.listeners.after.event_initialized.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end

            -- Send program output to the REPL for every language (delve and java-debug
            -- otherwise use a terminal or drop it). Explicit launch.json values win.
            dap.listeners.on_config["mine.output"] = function(config)
                if config.type == "go" and config.outputMode == nil then
                    return vim.tbl_extend("force", config, { outputMode = "remote" })
                end
                if config.type == "java" and config.request == "launch" and config.console == nil then
                    return vim.tbl_extend("force", config, { console = "internalConsole" })
                end
                return config
            end

            -- Tell in the REPL when the debuggee exits and the session closes, since the UI stays open
            dap.listeners.after.event_exited["mine.repl_end"] = function(_, body)
                require("dap.repl").append(("[dap] Process exited with code %s"):format(body.exitCode))
            end
            dap.listeners.after.event_initialized["mine.repl_end"] = function(session)
                session.on_close["mine.repl_end"] = function()
                    require("dap.repl").append("[dap] Debug session ended")
                end
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
    {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "delve" } },
    },
}
