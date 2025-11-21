return {
    "rmagatti/auto-session",
    lazy = false,
    init = function()
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {
        suppressed_dirs = { "~/", "~/Downloads" },
        close_filetypes_on_save = { "toggleterm", "checkhealth" },
        log_level = "error",
    },
}
