# https://github.com/leoluz/nvim-dap-go/blob/b4421153ead5d726603b02743ea40cf26a51ed5f/lua/dap-go.lua

local ts = require(PREFIX .. "treesitter.go_test")
local M = {
    last_testname = "",
    last_testpath = "",
    test_buildflags = "",
    test_verbose = false,
}

local function debug_test(testname, testpath, build_flags, extra_args, custom_config)
    local dap = require("dap")

    local config = {
        type = "go",
        name = testname,
        request = "launch",
        mode = "test",
        program = testpath,
        args = { "-test.run", "^" .. testname .. "$" },
        buildFlags = build_flags,
        outputMode = "remote",
    }
    config = vim.tbl_deep_extend("force", config, custom_config or {})

    if not vim.tbl_isempty(extra_args) then
        table.move(extra_args, 1, #extra_args, #config.args + 1, config.args)
    end

    dap.run(config)
end

function M.debug_test(custom_config)
    local test = ts.closest_test()

    if test.name == "" or test.name == nil then
        vim.notify("no test found")
        return false
    end

    M.last_testname = test.name
    M.last_testpath = test.package

    local msg = string.format("starting debug session '%s : %s'...", test.package, test.name)
    vim.notify(msg)

    local extra_args = {}
    if M.test_verbose then
        extra_args = { "-test.v" }
    end

    debug_test(test.name, test.package, M.test_buildflags, extra_args, custom_config)

    return true
end

function M.debug_last_test()
    local testname = M.last_testname
    local testpath = M.last_testpath

    if testname == "" then
        vim.notify("no last run test found")
        return false
    end

    local msg = string.format("starting debug session '%s : %s'...", testpath, testname)
    vim.notify(msg)

    local extra_args = {}
    if M.test_verbose then
        extra_args = { "-test.v" }
    end

    debug_test(testname, testpath, M.test_buildflags, extra_args)

    return true
end

return M
