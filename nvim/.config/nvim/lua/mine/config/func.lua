function R(name)
    require("plenary.reload").reload_module(name)
end

function CDProjectRoot()
    local get_root = require(PREFIX .. "utils.path").get_root
    vim.cmd.lcd(get_root())
end
