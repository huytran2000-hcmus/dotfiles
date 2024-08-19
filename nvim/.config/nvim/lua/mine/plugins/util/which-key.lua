return {
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    init = function()
        -- which-key
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        plugins = {
            registers = false,
        }
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.add({
            { "<leader>b",  group = "buffer" },
            { "<leader>d",  group = "debug" },
            { "<leader>f",  group = "fuzzy" },
            { "<leader>fg", group = "git" },
            { "<leader>q",  group = "quickfix" },
            { "<leader>s",  group = "wkspace" },
            { "<leader>t",  group = "toggle" },
            { "<leader>w",  group = "window" },
            { "[",          group = "prev" },
            { "]",          group = "next" },
            { "g",          group = "go" },
            { "<leader>w",  proxy = "<c-w>",   group = "windows" }, -- proxy to window mappings
            {
                "<leader>b",
                group = "buffers",
                expand = function()
                    return require("which-key.extras").expand.buf()
                end
            },
        })
    end
}
