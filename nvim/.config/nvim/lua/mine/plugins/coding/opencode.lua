return {
    {
        "nickjvandyke/opencode.nvim",
        keys = {
            {
                "<leader>aa",
                function()
                    require("opencode").ask("@this: ")
                end,
                mode = { "n", "x" },
                desc = "Ask opencode",
            },
            {
                "<leader>as",
                function()
                    require("opencode").select()
                end,
                mode = { "n", "x" },
                desc = "Select opencode action",
            },
            {
                "go",
                function()
                    return require("opencode").operator("@this")
                end,
                mode = { "n", "x" },
                expr = true,
                desc = "Send range to opencode",
            },
            {
                "goo",
                function()
                    return require("opencode").operator("@this") .. "_"
                end,
                expr = true,
                desc = "Send line to opencode",
            },
            {
                "<leader>ag",
                function()
                    return require("opencode").operator("@this ...")
                end,
                mode = { "n", "x" },
                expr = true,
                desc = "Draft range for opencode",
            },
            {
                "<leader>agg",
                function()
                    return require("opencode").operator("@this ...") .. "_"
                end,
                expr = true,
                desc = "Draft line for opencode",
            },
        },
        config = function()
            vim.g.opencode_opts = {}
        end,
    },
}
