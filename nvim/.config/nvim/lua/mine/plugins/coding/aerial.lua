return {
    "stevearc/aerial.nvim",
    cmd          = { "AerialOpen", "AerialInfo" },
    keys         = {
        {
            "<leader>fs",
            function()
                require('telescope').load_extension('aerial')
                require("telescope").extensions.aerial.aerial()
            end,
            desc = "Open Aerial "
        }
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    opts         = {
        backends = { "lsp", "treesitter", "markdown", "man" },
        default_direction = "prefer_right",
        attach_mode = "global",
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
            "Constant",
            "Variable",
            "Field"
        },
        highlight_closest = true,
        highlight_on_hover = true,
        show_guides = true,
        icons = require(PREFIX .. "config").icons.lsp_symbol
    },
    config       = function(_, opts)
        require("aerial").setup(opts)
    end
}
