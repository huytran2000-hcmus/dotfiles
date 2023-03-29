return {
    -- https://github.com/catppuccin/nvim
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
            -- :h background
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false,   -- Force no bold
        styles = {
            comments = { "italic" },
            functions = { "bold" },
            conditionals = {},
            -- keywords = { "italic" },
            -- loops = {},
            -- strings = {},
            -- variables = {},
            -- numbers = {},
            -- booleans = {},
            -- properties = {},
            -- types = {},
            -- operators = {},
        },
        -- color_overrides = {},
        -- custom_highlights = {},
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            which_key = true,
            lsp_trouble = true,
            notify = false,
            mini = false,
            -- For
            -- more
            -- plugins
            -- integrations
            -- please
            -- scroll
            -- down
            -- (https://github.com/catppuccin/nvim#integrations)
        },
    }
}
