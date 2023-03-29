PREFIX = "mine."
local require = function(module)
    return require(PREFIX..module)
end
require("utils")

require("config").setup()
