return {
    -- https://github.com/folke/tokyonight.nvim
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
        style = "moon",
        light_style = "day",
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            functions = { bold = true },
            -- keywords = { italic = true },
            -- varibles = {},
            sidebars = "dark",
            floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = true,
    },
}
