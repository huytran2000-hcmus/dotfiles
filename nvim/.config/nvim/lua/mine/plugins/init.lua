local prefix = PREFIX .. "plugins."
return {
    { import = prefix .. "ui" },
    { import = prefix .. "editor" },
    { import = prefix .. "coding" },
    { import = prefix .. "colorscheme" },
    { import = prefix .. "lsp" },
    { import = prefix .. "dap" },
    { import = prefix .. "util" },
}
