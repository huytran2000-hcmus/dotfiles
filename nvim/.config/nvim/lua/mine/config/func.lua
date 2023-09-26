function R(name)
    require("plenary.reload").reload_module(name)
end

function CDProjectRoot()
    local get_root = require(PREFIX .. "utils.path").get_root
    vim.cmd.lcd(get_root())
end

function LoadLaunchJSON(path)
    require("dap.ext.vscode").load_launchjs(path, { delve = { "go" } })
end
