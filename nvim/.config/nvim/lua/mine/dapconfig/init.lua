-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
return {
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
}
