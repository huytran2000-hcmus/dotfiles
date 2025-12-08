return {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
        max_time = 3000,
        disabled_filetypes = {
            dbui = true,
        },
    }
    -- opts = function()
    --     local opts = require("hardtime.config").config
    --     opts['max_time'] = 2000
    --     table.insert(opts["disabled_filetypes"], "dbui")
    --     opts["disable_mouse"] = false
    --     P(opts)
    --
    --
    --     return opts
    -- end,
}
