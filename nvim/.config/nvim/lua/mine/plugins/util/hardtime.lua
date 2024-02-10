return {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    lazy = false,
    keys = {
        { "j", "v:count == 0 ? 'gj' : 'j'", expr = true },
        { "k", "v:count == 0 ? 'gk' : 'k'", expr = true }
    },
    opts = {},
}
