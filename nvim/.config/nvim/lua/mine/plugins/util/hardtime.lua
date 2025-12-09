return {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = function()
        local opts = require("hardtime.config").config
        table.insert(opts["disabled_filetypes"], "dbui")
        opts["disable_mouse"] = false

        return opts
    end,
}
