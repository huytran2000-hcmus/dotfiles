return {
    "akinsho/toggleterm.nvim",
    opts = {
        open_mapping = [[<C-\>]],
        autochdir = false,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_mode = true,
        -- direction = "float",
        close_on_exit = true,
        -- shell = "bin/bash",
        -- auto_scroll = true,
        -- float_opts = {
        --     border = "curved",
        --     winblend = 3,
        -- },
        winbar = {
            enabled = true,
            name_formatter = function(term)
                return term.name
            end
        }
    }
}
