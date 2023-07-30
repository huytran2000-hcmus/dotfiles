local noremap = function(mode, lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", opts, { remap = false, silent = true }))
end

NNOREMAP = function(lhs, rhs, opts)
    noremap({ "n", "v" }, lhs, rhs, opts)
end

INOREMAP = function(lhs, rhs, opts)
    noremap("i", lhs, rhs, opts)
end

TNOREMAP = function(lhs, rhs, opts)
    noremap("t", lhs, rhs, opts)
end

VNOREMAP = function(lhs, rhs, opts)
    noremap("v", lhs, rhs, opts)
end

AUGROUP = function(name)
    vim.api.nvim_create_augroup(name, { clear = true })
end

AUTOCMD = function(event, opts)
    vim.api.nvim_create_autocmd(event, opts)
end

CLEAR_AUTOCMD = function(opts)
    vim.api.nvim_clear_autocmds(opts)
end

CMD = function(name, command, opts)
    vim.api.nvim_create_user_command(name, command, opts)
end

function P(obj)
    print(vim.inspect(obj))
end

local M = {}
function M.has(plugin)
    return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.notify(msg)
    vim.notify(msg, vim.log.levels.INFO)
end

return M
