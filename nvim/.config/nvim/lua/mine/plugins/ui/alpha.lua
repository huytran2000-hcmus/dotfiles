return {
    -- https://github.com/goolord/alpha-nvim
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.buttons.val = {
            dashboard.button("e", "  New file", "<cmd>ene<CR>"),
            dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
            dashboard.button("o", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
            dashboard.button("r", "  Load last session", "<cmd>:SessionManager load_last_session<CR>"),
            dashboard.button("s", "  Restore Session", "<cmd>:SessionManager load_session<CR>"),
            dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end
        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.opts.layout[1].val = 8
        return dashboard
    end,
    config = function(_, dashboard)
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
