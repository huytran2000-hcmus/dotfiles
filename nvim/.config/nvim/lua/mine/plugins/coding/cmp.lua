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
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            }
        },
        {
            "windwp/nvim-autopairs",
            opts = {}
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
                { name = "nvim_lsp",               keyword_length = 2, max_item_count = 10 },
                { name = "luasnip" },
                { name = "nvim_lua" },
                { name = "nvim_lsp_signature_help" },
                { name = "buffer",                 keyword_length = 3 },
                { name = "path" },
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
            mapping = cmp.mapping.preset.insert {
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),
                ["<C-l>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        return cmp.complete_common_string()
                    end
                    fallback()
                end, { "i", "c" }),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if has_words_before() then
                        cmp.confirm({
                            select = true,
                            behavior = cmp.ConfirmBehavior.Replace,
                        })
                    else
                        fallback()
                    end
                end),
                ["<C-n>"] = cmp.mapping(function()
                    local ls = require("luasnip")
                    ls.jump(1)
                end),
                ["<C-p>"] = cmp.mapping(function()
                    local ls = require("luasnip")
                    ls.jump(-1)
                end),
            },
            formatting = {
                fields = { "menu", "abbr", "kind" },
                format = function(entry, item)
                    local menu_icons = require(PREFIX .. "config").icons.menu
                    local kind_icons = require(PREFIX .. "config").icons.kind
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
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on(
            "confirm_done",
            cmp_autopairs.on_confirm_done()
        )
    end
}
