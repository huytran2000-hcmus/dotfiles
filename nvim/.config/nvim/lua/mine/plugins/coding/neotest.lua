return {
    {
        -- https://github.com/nvim-neotest/neotest
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
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
        opts = {
            -- Language specs add adapters as { ["<adapter module>"] = <adapter options> }
            adapters = {},
            status = { virtual_text = true },
            output = { open_on_run = true },
        },
        config = function(_, opts)
            local adapters = {}
            for name, adapter_opts in pairs(opts.adapters) do
                if adapter_opts ~= false then
                    local adapter = require(name)
                    local meta = getmetatable(adapter)
                    if meta and meta.__call then
                        adapter = adapter(type(adapter_opts) == "table" and adapter_opts or {})
                    end
                    adapters[#adapters + 1] = adapter
                end
            end
            opts.adapters = adapters
            require("neotest").setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "neotest-output", "neotest-output-panel" },
                callback = function(args)
                    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true, desc = "Close neotest output" })
                end,
            })
        end,
    },
}
