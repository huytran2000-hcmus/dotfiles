return {
    -- https://github.com/Shatur/neovim-session-manager
    "Shatur/neovim-session-manager",
    cmd = "SessionManager",
    init = function()
        vim.cmd.cabbrev("ssm", "SessionManager")
        vim.cmd.cabbrev("ssl", "SessionManager load_session")
    end,
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    opts = function()
        return {
            autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
            autosave_last_session = true,
            max_path_length = 0, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
        }
    end
}
