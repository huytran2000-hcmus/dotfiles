local on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local opts = function(desc)
        return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
        }
    end

    api.config.mappings.default_on_attach(bufnr)

    local lib = require("nvim-tree.lib")
    local view = require("nvim-tree.view")

    local function vsplit_preview()
        -- open as vsplit on current node
        local action = "vsplit"
        local node = lib.get_node_at_cursor()
        -- Just copy what"s done normally with vsplit
        if not node and node.link_to and not node.nodes then
            require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
        elseif node.nodes ~= nil then
            lib.expand_or_collapse(node)
        else
            require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
        end

        -- Finally refocus on tree if it was lost
        view.focus()
    end

    local function edit_or_open()
        -- open as vsplit on current node
        local action = "edit"
        local node = lib.get_node_at_cursor()

        -- Just copy what"s done normally with vsplit
        if node.link_to and not node.nodes then
            require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
            view.close() -- Close the tree if file was opened
        elseif node.nodes ~= nil then
            lib.expand_or_collapse(node)
        else
            require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
            view.close() -- Close the tree if file was opened
        end
    end

    NNOREMAP("d", "<nop>", opts("Remove remap d"))

    -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    NNOREMAP("R", api.fs.rename, opts("Rename"))
    NNOREMAP("a", api.fs.create, opts("Create"))
    NNOREMAP("D", api.fs.remove, opts("Delete"))
    NNOREMAP("x", api.fs.cut, opts("Cut"))
    NNOREMAP("c", api.fs.copy.node, opts("Copy"))
    NNOREMAP("P", api.fs.paste, opts("Paste"))
    NNOREMAP("p", api.node.navigate.parent, opts("Parent Directory"))
    NNOREMAP(".", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
    NNOREMAP("h", api.node.navigate.parent_close, opts("Close Directory"))
    NNOREMAP("H", api.tree.collapse_all, opts("Collapse"))
    NNOREMAP("l", edit_or_open, opts("Edit and Close Tree"))
    NNOREMAP("L", vsplit_preview, opts("Vertical split preview"))
    NNOREMAP("K", api.node.show_info_popup, opts("Info"))
    NNOREMAP("r", function()
        local root_path = require(PREFIX .. "utils.path").get_root("#")
        api.tree.change_root(root_path)
    end, opts("Reset root"))
    NNOREMAP("<leader>mn", api.marks.navigate.next, { desc = "Navigate to next mark file" })
    NNOREMAP("<leader>mp", api.marks.navigate.prev, { desc = "Navigate to previous mark file" })
    NNOREMAP("<leader>ms", api.marks.navigate.select, { desc = "Mark file picker" })
end


return {
    {
        -- https://github.com/nvim-tree/nvim-tree.lua
        "nvim-tree/nvim-tree.lua",
        cmd = "NvimTreeOpen",
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.opt.termguicolors = true
        end,
        keys = {
            {
                "<leader>e",
                function()
                    require("nvim-tree.api").tree.open()
                end,
                desc = "Open nvim-tree"
            },
            {
                "<leader>E",
                function()
                    require("nvim-tree.api").tree.change_root(vim.fn.expand("%:p:h"))
                    require("nvim-tree.api").tree.open()
                end,
                desc = "Open nvim-tree at current file directory"
            },
            {
                "<leader>te",
                function() require("nvim-tree.api").tree.toggle({ focus = false }) end,
                desc = "Toggle without focus nvim-tree"
            },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            on_attach = on_attach,
            renderer = {
                icons = {
                    glyphs = {
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    }
                }
            },
            git = {
                enable = true,
                ignore = false,
            },
            sync_root_with_cwd = true,
            -- respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                -- update_root = true,
            }
        },
    }

}
