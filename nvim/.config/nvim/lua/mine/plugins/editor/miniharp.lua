return {
    "vieitesss/miniharp.nvim",
    version = "*",
    opts = {
        autoload = true,
        autosave = true,
        show_on_autoload = false,
        notifications = true,
        ui = {
            position = "center",
            show_hints = true,
            enter = true,
        },
    },
    keys = {
        {
            "<leader>mm",
            function()
                require("miniharp").toggle_file()
            end,
            desc = "Toggle file mark"
        },
        {
            "<leader>mn",
            function()
                require("miniharp").next()
            end,
            desc = "Next file mark"
        },
        {
            "<leader>mp",
            function()
                require("miniharp").prev()
            end,
            desc = "Previous file mark"
        },
        {
            "<leader>ml",
            function()
                require("telescope").extensions.miniharp.marks()
            end,
            desc = "Telescope marks list"
        },
        {
            "<leader>mL",
            function()
                require("miniharp").enter_list()
            end,
            desc = "Enter marks list"
        },
        {
            "<leader>m1",
            function()
                require("miniharp").go_to(1)
            end,
            desc = "Go to mark 1"
        },
        {
            "<leader>m2",
            function()
                require("miniharp").go_to(2)
            end,
            desc = "Go to mark 2"
        },
        {
            "<leader>m3",
            function()
                require("miniharp").go_to(3)
            end,
            desc = "Go to mark 3"
        },
        {
            "<leader>m4",
            function()
                require("miniharp").go_to(4)
            end,
            desc = "Go to mark 4"
        },
    },
}
