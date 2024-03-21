return {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    keys = {
        { "j", "v:count == 0 ? 'gj' : 'j'", expr = true },
        { "k", "v:count == 0 ? 'gk' : 'k'", expr = true }
    },
    opts = function()
        local opts = require("hardtime.config").config
        table.insert(opts["disabled_filetypes"], "dbui")

        return opts
    end,
}
