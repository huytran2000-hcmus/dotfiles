return {
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    init = function()
        -- which-key
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        triggers_nowait = {
            "`",
            "'",
            "g`",
            "g'",
            --'"',
            --"<c-r>",
            "z=",
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register({
            ["g"] = { name = "+go" },
            ["]"] = { name = "+next" },
            ["["] = { name = "+prev" },
            ["<leader>f"] = {
                name = "+fuzzy",
                ["g"] = {
                    name = "git",
                }
            },
            ["<leader>d"] = { name = "+debug" },
            ["<leader>b"] = { name = "+buffer" },
            ["<leader>s"] = { name = "+wkspace" },
            ["<leader>w"] = { name = "+window" },
            ["<leader>q"] = { name = "+quickfix" },
            ["<leader>t"] = { name = "+toggle" },
        })
    end
}
