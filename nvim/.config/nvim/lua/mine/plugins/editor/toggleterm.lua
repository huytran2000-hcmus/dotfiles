local set_opfunc = vim.fn[vim.api.nvim_exec([[
  func s:set_opfunc(val)
    let &opfunc = a:val
  endfunc
  echon get(function('s:set_opfunc'), 'name')
]], true)]

return {
    "akinsho/toggleterm.nvim",
    keys = {
        { [[<C-\>]] },
        { [[<C-[>]], [[<C-\><C-n>]], mode = "t", ft = "toggleterm" },
        { [[<leader><c-\><c-\>]], function()
            set_opfunc(function(motion_type)
                require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
            end)
            vim.api.nvim_feedkeys("g@_", "n", false)
        end }
    },
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
        }
    }
}
