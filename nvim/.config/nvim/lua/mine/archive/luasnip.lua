local ls = require("luasnip") --{{{
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip").config.setup({ store_selection_keys = "<A-p>" })

-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#config-reference
ls.setup({
    history = true,
    update_events = {"TextChanged", "TextChangedI"},
    enable_autosnippets = true,
    ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
            active = {
                virt_text = {{"●", "GruvboxOrange"}},
            }
        },
    }
})

vim.keymap.set({"i", "s"}, "<C-k>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jumpable()
    end
end, {silent = true})

