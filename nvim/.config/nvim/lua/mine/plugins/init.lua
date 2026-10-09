local prefix = PREFIX .. "plugins."
return {
    { import = prefix .. "ui" },
    { import = prefix .. "editor" },
    { import = prefix .. "coding" },
    { import = prefix .. "colorscheme" },
    { import = prefix .. "lsp" },
    { import = prefix .. "dap" },
    { import = prefix .. "util" },
    -- Imported last: lists in lang/* (e.g. mason/treesitter ensure_installed) are only
    -- appended when the core spec declaring opts_extend has already been merged.
    { import = prefix .. "lang" },
}
