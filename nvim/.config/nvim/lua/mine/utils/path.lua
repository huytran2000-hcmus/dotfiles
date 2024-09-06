local M = {}
M.root_patterns = { ".git", "Makefile", "go.mod" }

function M.get_root(buf)
    local bufnr = buf or 0
    if type(buf) == "string" then
        bufnr = vim.fn.bufnr(buf)
    end

    local bufpath = vim.api.nvim_buf_get_name(bufnr)
    ---@type string?
    bufpath = bufpath ~= "" and vim.loop.fs_realpath(bufpath) or nil
    local roots = {}
    if bufpath then
        roots = M.dectect_lsp(bufpath, bufnr)
    end

    local root = roots and roots[1]
    if not root then
        bufpath = bufpath and vim.fs.dirname(bufpath) or vim.loop.cwd()
        root = vim.fs.find(M.root_patterns, { path = bufpath, upward = true })[1]
        root = root and vim.fs.dirname(root) or vim.loop.cwd()
    end
    return root
end

function M.dectect_lsp(bufpath, bufnr)
    local roots = {}
    local client_roots = {}
    for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        local workspace = client.config.workspace_folders
        for _, ws in pairs(workspace or {}) do
            local fname = vim.uri_to_fname(ws.uri)
            if not vim.tbl_contains(roots, fname) then
                roots[#roots + 1] = fname
            end
        end

        if client.root_dir and not vim.tbl_contains(roots, client.root_dir) then
            roots[#roots + 1] = client.root_dir
        end
    end

    for _, root in pairs(roots) do
        if root and bufpath:find(root, 1, true) == 1 then
            return { root }
        end
    end

    return roots
end

return M
