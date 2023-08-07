local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local attach_mappings = function(prompt_bufnr, map)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        print(vim.inspect(selection))
        vim.api.nvim_put({ selection[1] }, "", false, false)
    end)
    return true
end


local colors = function(otps)
    otps = otps or {}

    pickers.new(otps, {
        prompt_title = "Color",
        finder = finders.new_table {
            results = {
                { "red",   "#ff0000" },
                { "green", "#00ff00" },
                { "blue",  "#0000ff" },
            },
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry[1],
                    ordinal = entry[1],
                }
            end
        },
        sorter = conf.generic_sorter(otps),
        attach_mappings = attach_mappings,
    }):find()
end

colors(require("telescope.themes").get_dropdown {})
