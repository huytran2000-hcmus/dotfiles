local M = {}

M.icons = {
    completion_kind = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = " ",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = ""
    },
    lsp_symbol = {
        File = '󰈙 ',
        Module = ' ',
        Namespace = ' ',
        Package = ' ',
        Class = ' ',
        Constructor = "",
        Field = ' ',
        Property = ' ',
        Method = '󰆧 ',
        Object = ' ',
        Enum = ' ',
        Interface = ' ',
        Function = '󰊕 ',
        Variable = ' ',
        Constant = '󰏿 ',
        String = ' ',
        Number = '󰎠 ',
        Boolean = ' ',
        Array = '󰅪 ',
        Key = '󰌋 ',
        Null = ' ',
        EnumMember = ' ',
        Struct = ' ',
        Event = ' ',
        Operator = '󰆕 ',
        TypeParameter = ' '
    },
    diagnostic = {
        DiagnosticSignError = "󰅚",
        DiagnosticSignWarn = "",
        DiagnosticSignHint = "󰌶",
        DiagnosticSignInfo = "",
    },
    menu = {
        nvim_lsp = "[LSP]",
        vsnip = "[snippet]",
        buffer = "[buf]",
        path = "[fs]",
        nvim_lua = "[nvim]",
    }
}


function M.setup(opts)
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    require(PREFIX .. "config.option")
    require("lazy").setup(PREFIX .. "plugins", {
        defaults = {
            lazy = false,
            -- version = nil
        },
        spec = nil,
        install = {
            missing = true,
            colorscheme = { "habamax" }
        },
        ui = {
            icons = {
                cmd = " ",
                config = "",
                event = "",
                ft = " ",
                init = " ",
                import = " ",
                keys = " ",
                lazy = "󰒲 ",
                loaded = "●",
                not_loaded = "○",
                plugin = " ",
                runtime = " ",
                source = " ",
                start = "",
                task = "✔ ",
                list = {
                    "●",
                    "➜",
                    "★",
                    "‒",
                }
            }
        }
    })

    AUTOCMD("User", {
        pattern = "VeryLazy",
        callback = function()
            local prefix = PREFIX .. "config."
            require(prefix .. "func")
            require(prefix .. "autocmd")
            require(prefix .. "keymap")
            require(prefix .. "cmd")
        end
    })
end

-- setmetatable(M, {
--     __index = function(_, key)
--         return vim.deepcopy(defaults)[key]
--     end,
-- })

return M
