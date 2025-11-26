return {
    "EdenEast/nightfox.nvim",
    lazy = true,
    priority = 1000,
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
