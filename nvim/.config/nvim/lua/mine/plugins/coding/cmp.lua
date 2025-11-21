local function has_words_before()
    local unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line_range = vim.api.nvim_buf_get_lines(0, line - 1, line, true)

    return col ~= 0 and line_range[1]:sub(col, col):match("%s") == nil
end

return {
    -- https://github.com/hrsh7th/nvim-cmp
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    init = function()
        vim.opt.shortmess = vim.opt.shortmess + { c = "true" }
    end,
    dependencies = {
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-buffer",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        {
            "L3MON4D3/LuaSnip",
            -- tag = "v<CurrentMajor>.*",
            build = "make install_jsregexp", -- needed for snippet transformation
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        },
        {
            "windwp/nvim-autopairs",
            opts = {
                fast_wrap = {},
            }
        }
    },
    opts = function()
        local cmp = require("cmp")
        return {
            completion = {
                completeopt = "menuone,preview,noselect,noinsert,longest"
            },
            --[[
            cmp can't work by itself. It need source engines to get suggestions
            name = source to work with cmp
            keyword_length = number charater before trigger completion
            priority = priority of the source
            max_item_count = maximum items for a source
            --]]
            sources = {
                {
                    name = "nvim_lsp",
                    priority = 100,
                    keyword_length = 2,
                    max_item_count = 10,
                    entry_filter = function(entry, ctx)
                        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
                    end
                },
                { name = "copilot",                 priority = 10 },
                { name = "nvim_lsp_signature_help", priority = 5 },
                { name = "luasnip",                 priority = 5 },
                { name = "nvim_lua",                priority = 3 },
                { name = "buffer",                  priority = 2 },
                { name = "path",                    priority = 1 },
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                completion = {
                    border = "rounded",
                    side_padding = 3,
                },
                documentation = {
                    border = "rounded",
                    side_padding = 3,
                },
            },
            preselect = cmp.PreselectMode.None,
            mapping = cmp.mapping.preset.insert {
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),
                ["<C-l>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        return cmp.complete_common_string()
                    end
                    fallback()
                end, { "i", "c" }),
                ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local ls = require("luasnip")
                        if ls.expandable() then
                            ls.expand()
                        elseif has_words_before() then
                            cmp.confirm({
                                select = true,
                                behavior = cmp.ConfirmBehavior.Replace,
                            })
                        else
                            fallback()
                        end
                    else
                        fallback()
                    end
                end),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    local ls = require("luasnip")
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif ls.locally_jumpable(1) then
                        ls.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            formatting = {
                fields = { "menu", "abbr", "kind" },
                format = function(entry, item)
                    local menu_icons = require(PREFIX .. "config").icons.menu
                    local kind_icons = require(PREFIX .. "config").icons.completion_kind
                    item.kind = string.format('%s %s', kind_icons[item.kind], item.kind)
                    item.menu = menu_icons[entry.source.name]
                    return item
                end
            },
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        local cmd_mappings = cmp.mapping.preset.cmdline({
            ['<C-j>'] = {
                c = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end,
            },
            ['<C-k>'] = {
                c = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end,
            },
            ['<C-p>'] = {
                c = function(fallback)
                    fallback()
                end
            },
            ['<C-n>'] = {
                c = function(fallback)
                    fallback()
                end
            }
        })
        cmp.setup(opts)
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmd_mappings,
            sources = {
                { name = 'buffer', keyword_length = 3 }
            }
        })
        cmp.setup.cmdline(':', {
            mapping = cmd_mappings,
            sources = cmp.config.sources({ -- cmdline source will not show when path source is available
                { name = 'path' }
            }, {
                { name = 'cmdline', keyword_length = 1, max_item_count = 10 },
            })
        })

        local remap = vim.api.nvim_set_keymap
        local npairs = require('nvim-autopairs')

        -- skip it, if you use another global object
        _G.MUtils = {}

        vim.g.completion_confirm_key = ""

        MUtils.completion_confirm = function()
            if vim.fn.pumvisible() ~= 0 then
                if vim.fn.complete_info()["selected"] ~= -1 then
                    require 'completion'.confirmCompletion()
                    return npairs.esc("<c-y>")
                else
                    vim.api.nvim_select_popupmenu_item(0, false, false, {})
                    require 'completion'.confirmCompletion()
                    return npairs.esc("<c-n><c-y>")
                end
            else
                return npairs.autopairs_cr()
            end
        end

        remap('i', '<CR>', 'v:lua.MUtils.completion_confirm()', { expr = true, noremap = true })
    end
}
