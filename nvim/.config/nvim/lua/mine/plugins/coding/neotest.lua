return {
    {
        -- https://github.com/nvim-neotest/neotest
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                -- https://github.com/fredrikaverpil/neotest-golang
                "fredrikaverpil/neotest-golang",
                version = "*",
            },
        },
        -- Java test keymaps are buffer-local (jdtls) in plugins/coding/java.lua and override these
        keys = {
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run file" },
            { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end,                           desc = "Run all test files" },
            { "<leader>tr", function() require("neotest").run.run() end,                                       desc = "Run nearest test" },
            { "<leader>tl", function() require("neotest").run.run_last() end,                                  desc = "Run last test" },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                   desc = "Debug nearest test" },
            { "<leader>tD", function() require("neotest").run.run_last({ strategy = "dap" }) end,              desc = "Debug last test" },
            { "<leader>ta", function() require("neotest").run.attach() end,                                    desc = "Attach to test" },
            { "<leader>ts", function() require("neotest").summary.toggle() end,                                desc = "Toggle summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end,                           desc = "Toggle output panel" },
            { "<leader>tS", function() require("neotest").run.stop() end,                                      desc = "Stop" },
            { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                desc = "Toggle watch" },
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")({}),
                },
                status = { virtual_text = true },
                output = { open_on_run = true },
            })
        end,
    },
}
