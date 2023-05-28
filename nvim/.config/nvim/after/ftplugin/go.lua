AUTOCMD("BufWritePre", {
    callback = function()
        vim.lsp.buf.code_action({
            context = {
                only = {
                    "source.organizeImports"
                }
            },
            apply = true
        })
    end
})

CMD("LoadLaunchJSON", function(opts)
    P(opts)
    require("dap.ext.vscode").load_launchjs(opts.args, { delve = { "go" } })
end, {
    nargs = 1,
    desc = "Load launch.json for dap.nvim"
})
