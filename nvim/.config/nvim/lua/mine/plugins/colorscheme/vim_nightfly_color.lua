return {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = false,
    priority = 1000,
    init = function()
        vim.g.nightflyVirtualTextColor = true
        vim.g.nightflyUndercurls = false
        vim.g.nightflyWinSeparator = 2

        vim.api.nvim_create_autocmd("UIEnter", {
            command = "colorscheme nightfly"
        })
    end
}
