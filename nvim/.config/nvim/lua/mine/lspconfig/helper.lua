function support(capability)
    vim.lsp.get_clients()[1]:supports_method(capability)
end
