local term

local function toggle_terminal()
    if not term then
        local Terminal = require("toggleterm.terminal").Terminal
        term = Terminal:new({
            cmd = "opencode",
            direction = "tab",
            count = 9,
            on_open = function(t)
                -- <Esc> and <C-[> are the same key. The global toggleterm mapping would swallow it,
                -- so send it through to opencode (interrupts a running prompt).
                vim.keymap.set("t", "<C-[>", "<C-[>", { buffer = t.bufnr, desc = "Send <Esc> to opencode" })
                vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { buffer = t.bufnr, desc = "Leave terminal mode" })
            end,
        })
    end
    term:toggle()
end

return {
    {
        "nickjvandyke/opencode.nvim",
        dependencies = { "akinsho/toggleterm.nvim" },
        keys = {
            {
                "<leader>ao",
                toggle_terminal,
                desc = "Toggle opencode terminal",
            },
            {
                "<leader>aa",
                function()
                    require("opencode").ask("@this: ")
                end,
                mode = { "n", "x" },
                desc = "Ask opencode",
            },
            {
                "<leader>as",
                function()
                    require("opencode").select()
                end,
                mode = { "n", "x" },
                desc = "Select opencode action",
            },
            {
                "go",
                function()
                    return require("opencode").operator("@this")
                end,
                mode = { "n", "x" },
                expr = true,
                desc = "Send range to opencode",
            },
            {
                "goo",
                function()
                    return require("opencode").operator("@this") .. "_"
                end,
                expr = true,
                desc = "Send line to opencode",
            },
            {
                "<leader>ag",
                function()
                    return require("opencode").operator("@this ...")
                end,
                mode = { "n", "x" },
                expr = true,
                desc = "Draft range for opencode",
            },
            {
                "<leader>agg",
                function()
                    return require("opencode").operator("@this ...") .. "_"
                end,
                expr = true,
                desc = "Draft line for opencode",
            },
        },
        config = function()
            vim.g.opencode_opts = {}
        end,
    },
}
