function R(name)
    require("plenary.reload").reload_module(name)
end

function P(obj)
    print(vim.inspect(obj))
end
