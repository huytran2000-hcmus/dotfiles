return {
    on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = 0 }
        NNOREMAP("K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "Hover lsp help" }))
        INOREMAP("<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", bufopts, { desc = "Get signature help" }))
        -- NNOREMAP("gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "Go to definition" }))
        -- NNOREMAP("gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "Go to declaration" }))
        NNOREMAP("gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", bufopts, { desc = "Go to type definition" }))
        NNOREMAP("gi", function()
            if Has("telescope.nvim") then
                require("telescope.builtin").lsp_implementations()
                return
            end
            vim.lsp.buf.implementations()
        end, vim.tbl_extend("force", bufopts, { desc = "Go to implementations" }))
        NNOREMAP("gr", function()
            if Has("telescope.nvim") then
                require("telescope.builtin").lsp_references()
                return
            end
            vim.lsp.buf.references()
        end, vim.tbl_extend("force", bufopts, { desc = "Go to references" }))

        NNOREMAP('<space>sa', vim.lsp.buf.add_workspace_folder,
            vim.tbl_extend("force", bufopts, { desc = "Add workspace folder" }))
        NNOREMAP('<space>sr', vim.lsp.buf.remove_workspace_folder,
            vim.tbl_extend("force", bufopts, { desc = "Remove workspace folder" }))
        NNOREMAP('<space>sl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", bufopts, { desc = "Remove workspace folder" }))

        NNOREMAP("<space>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename identifier" }))
        NNOREMAP("<space>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "Code action" }))
        NNOREMAP("<space>fm", function()
            vim.lsp.buf.format { async = true }
        end, vim.tbl_extend("force", bufopts, { desc = "Format buffer" }))
    end
}
