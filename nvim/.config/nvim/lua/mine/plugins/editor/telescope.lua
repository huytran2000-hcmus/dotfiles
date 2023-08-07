local opts = function()
    local actions = require("telescope.actions")
    return {
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = {
                "truncate",
                shorten = { len = 1, exclude = { 1, -2, -1 } },
            },
            cache_picker = {
                num_pickers = 5,
            },
            preview = {
                filesize_limit = 0.5,
            },
            mappings = {
                i = {
                    ["<Cr>"] = actions.select_default,
                    ["<C-c>"] = actions.close,
                    ["<C-/>"] = actions.which_key,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    -- ["<C-h>"] = actions.moveper
                    ["<C-n>"] = actions.cycle_history_next,
                    ["<C-p>"] = actions.cycle_history_prev,
                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,
                    ["<C-l>"] = actions.complete_tag,
                },
                n = {
                    ["<Cr>"] = actions.select_default,
                    ["<Esc>"] = actions.close,
                    ["<?>"] = actions.which_key,
                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["H"] = actions.move_to_top,
                    ["M"] = actions.move_to_middle,
                    ["L"] = actions.move_to_bottom,
                    ["gg"] = actions.move_to_top,
                    ["G"] = actions.move_to_bottom,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,
                }
            }
        },
        pickers = {
            find_files = {
                find_command = { "fd", "-HI", "-E", ".git", "-E", "node_modules" },
            },
            buffers = {
                sort_lastused = true,
                sort_mru = true,
            },
            colorscheme = {
                theme = "cursor",
                enable_preview = true,
            }
        },

    }
end

return {
    {
        -- https://github.com/nvim-telescope/telescope.nvim
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        init = function()
            vim.cmd.cabbrev("tl", "Telescope")
        end,
        keys = {
            {
                "<leader>ff",
                function() require("telescope.builtin").find_files() end,
                desc = "Fuzzy find files"
            },
            {
                "<leader>f%",
                function() require("telescope.builtin").current_buffer_fuzzy_find() end,
                desc = "Fuzzy find current buffer"
            },
            {
                "<leader>fe",
                function() require("telescope.builtin").live_grep() end,
                desc = "Fuzzy live grep"
            },
            {
                "<leader>fb",
                function() require("telescope.builtin").buffers() end,
                desc = "Fuzzy find in buffers"
            },
            {
                "<leader>fh",
                function() require("telescope.builtin").help_tags() end,
                desc = "Fuzzy find help tags"
            },
            {
                "<leader>f*",
                function() require("telescope.builtin").grep_string() end,
                desc = "Fuzzy find the string under cursor"
            },
            {
                "<leader>fd",
                function() require("telescope.builtin").diagnostics() end,
                desc = "Fuzzy find old files"
            },
            {
                "<leader>fo",
                function() require("telescope.builtin").oldfiles() end,
                desc = "Fuzzy find old files"
            },
            {
                "<leader>fr",
                function() require("telescope.builtin").resume() end,
                desc = "Resume last telescope picker"
            },
            {
                "<leader>fgb",
                function() require("telescope.builtin").git_branches(require('telescope.themes').get_dropdown()) end,
                desc = "Fuzzy checkout git branch"
            },
            {
                "<leader>fgt",
                function() require("telescope.builtin").git_status() end,
                desc = "Fuzzy check git file status"
            },
            {
                "<leader>fgc",
                function() require("telescope.builtin").git_commits() end,
                desc = "Fuzzy checkout and reset git commits"
            },
            {
                "<leader>fgh",
                function() require("telescope.builtin").git_bcommits() end,
                desc = "Fuzzy find git commits of current buffer"
            }
        },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            {
                "nvim-tree/nvim-web-devicons"
            }
        },
        opts = opts,
    },
}
