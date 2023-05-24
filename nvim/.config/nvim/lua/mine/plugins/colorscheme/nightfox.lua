return {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        vim.api.nvim_create_autocmd("UIEnter", {
            command = "colorscheme nightfox"
        })
    end,
    opts = {
        options = {
            transparent = false,
            terminal_colors = true,
            dim_inactive = true,
            module_default = true,
            styles = {
                comments = "italic",
                functions = "bold",
                keywords = "bold"
            }
        }
    }
}
