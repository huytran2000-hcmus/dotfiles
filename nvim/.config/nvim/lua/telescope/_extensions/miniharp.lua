local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local themes = require("telescope.themes")

local marks
marks = function(opts)
    local miniharp = require("miniharp")
    local results = {}

    for idx, mark in ipairs(miniharp.list()) do
        results[idx] = {
            idx = idx,
            file = mark.file,
            lnum = mark.lnum,
            col = mark.col,
        }
    end

    if vim.tbl_isempty(results) then
        vim.notify("No miniharp marks", vim.log.levels.INFO)
        return
    end

    opts = themes.get_dropdown(opts or {})

    pickers.new(opts, {
        prompt_title = "Miniharp Marks",
        finder = finders.new_table({
            results = results,
            entry_maker = function(entry)
                local path = vim.fn.fnamemodify(entry.file, ":~:.")

                return {
                    value = entry,
                    display = string.format("%d. %s:%d", entry.idx, path, entry.lnum),
                    ordinal = string.format("%s %d", path, entry.idx),
                    path = entry.file,
                    filename = entry.file,
                    lnum = entry.lnum,
                    col = entry.col,
                }
            end,
        }),
        previewer = conf.grep_previewer(opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()

                actions.close(prompt_bufnr)
                miniharp.go_to(selection.value.idx)
            end)

            local delete_mark = function()
                local selection = action_state.get_selected_entry()
                if not selection then return end
                require("miniharp.marks").remove_at(selection.value.idx)
                actions.close(prompt_bufnr)
                marks(opts)
            end

            map("i", "<C-d>", delete_mark)
            map("n", "<C-d>", delete_mark)

            return true
        end,
    }):find()
end

return require("telescope").register_extension({
    exports = {
        marks = marks,
    },
})
