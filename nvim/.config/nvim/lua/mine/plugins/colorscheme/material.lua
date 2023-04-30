return {
    -- https://github.com/marko-cerovac/material.nvim
    "marko-cerovac/material.nvim",
    lazy = true,
    init = function()
        -- material
        -- -- darker | lighter | oceanic | palenight | deep ocean
        vim.g.material_style = "deep ocean"
    end,
    opts = {
        contrast = {
            non_current_window = true
        },
        styles = {
            comments = { italic = true },
            functions = { bold = true },
            -- strings = { --[[ bold = true ]] },
            -- keywords = { italic = true },
            -- variables = {},
            -- operators = {},
            -- types = {},
        },
        lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )
        plugins = {
            "dap",
            "nvim-cmp",
            "nvim-navic",
            "nvim-tree",
            "telescope",
            "which-key",
            "nvim-web-devicons",
            -- "gitsigns",
            -- "dashboard",
            -- "hop",
            -- "indent-blankline",
            -- "lspsaga",
            -- "mini",
            -- "neogit",
            -- "neorg",
            -- "sneak",
            -- "trouble",
        },
        -- disable = {
        --     colored_cursor = false, -- Disable the colored cursor
        --     borders = false,        -- Disable borders between verticaly split windows
        --     background = false,     -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
        --     term_colors = false,    -- Prevent the theme from setting terminal colors
        --     eob_lines = false       -- Hide the end-of-buffer lines
        -- },
        -- high_visibility = {
        --     lighter = false,        -- Enable higher contrast text for lighter style
        --     darker = false          -- Enable higher contrast text for darker style
        -- },
        -- async_loading = true,       -- Load parts of the theme asyncronously for faster startup (turned on by default)
        -- custom_colors = nil,        -- If you want to everride the default colors, set this to a function
        -- custom_highlights = {},     -- Overwrite highlights with your own
    }
}
