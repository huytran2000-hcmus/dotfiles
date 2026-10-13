local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local themes = require("telescope.themes")

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO, { title = "Worktree" })
end

local function git(args, cwd)
    local result = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
    return result.code == 0, vim.trim(result.stdout or ""), vim.trim(result.stderr or "")
end

local function normalize(path)
    return (vim.fs.normalize(vim.fn.fnamemodify(path, ":p")):gsub("/$", ""))
end

local function list_worktrees()
    local ok, out, err = git({ "worktree", "list", "--porcelain" })
    if not ok then
        notify(err ~= "" and err or "Not a git repository", vim.log.levels.ERROR)
        return nil
    end

    local worktrees = {}
    local current
    for line in (out .. "\n\n"):gmatch("(.-)\n") do
        if line == "" then
            if current and not current.bare then
                current.main = #worktrees == 0
                table.insert(worktrees, current)
            end
            current = nil
        else
            local key, value = line:match("^(%S+)%s?(.*)$")
            if key == "worktree" then
                current = { path = normalize(value) }
            elseif current then
                if key == "HEAD" then
                    current.head = value:sub(1, 7)
                elseif key == "branch" then
                    current.branch = value:gsub("^refs/heads/", "")
                elseif key == "bare" then
                    current.bare = true
                elseif key == "detached" then
                    current.detached = true
                elseif key == "locked" then
                    current.locked = true
                elseif key == "prunable" then
                    current.prunable = true
                end
            end
        end
    end
    return worktrees
end

local function modified_buffers()
    local names = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
            local name = vim.api.nvim_buf_get_name(buf)
            table.insert(names, name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:."))
        end
    end
    return names
end

local function switch(path)
    path = normalize(path)
    local cwd = normalize(vim.fn.getcwd(-1, -1))
    if path == cwd then
        notify("Already in " .. vim.fn.fnamemodify(path, ":~"))
        return
    end

    local modified = modified_buffers()
    if #modified > 0 then
        notify("Save or discard unsaved buffers first:\n" .. table.concat(modified, "\n"), vim.log.levels.WARN)
        return
    end

    -- Reopen the same file in the new worktree when it has no saved session.
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file ~= "" and vim.bo.buftype == "" then
        local current_file_abs = normalize(current_file)
        if vim.startswith(current_file_abs, cwd .. "/") then
            vim.g.worktree_reopen_file = path .. current_file_abs:sub(#cwd + 1)
        end
    end

    vim.g.worktree_switching = true
    vim.cmd.cd(vim.fn.fnameescape(path))
    -- auto-session handles DirChanged in a vim.schedule callback; clear the
    -- flags after it ran so a later manual :cd is not treated as a switch.
    vim.schedule(function()
        vim.g.worktree_switching = nil
        vim.g.worktree_reopen_file = nil
    end)
end

local function branch_exists(ref)
    return (git({ "rev-parse", "--verify", "--quiet", ref }))
end

local function create(opts)
    opts = opts or {}
    local worktrees = list_worktrees()
    if not worktrees or #worktrees == 0 then
        return
    end
    local main = worktrees[1].path

    local function add(branch, path)
        local args = { "worktree", "add" }
        if branch_exists("refs/heads/" .. branch) or branch_exists("refs/remotes/origin/" .. branch) then
            vim.list_extend(args, { path, branch })
        else
            vim.list_extend(args, { "-b", branch, path })
        end

        notify("Creating worktree " .. vim.fn.fnamemodify(path, ":~") .. "...")
        vim.system(vim.list_extend({ "git" }, args), { cwd = main, text = true }, function(result)
            vim.schedule(function()
                if result.code ~= 0 then
                    notify(vim.trim(result.stderr or ""), vim.log.levels.ERROR)
                    return
                end
                notify("Created worktree " .. vim.fn.fnamemodify(path, ":~"))
                switch(path)
            end)
        end)
    end

    local function ask_path(branch)
        local default = vim.fn.fnamemodify(main, ":h")
            .. "/"
            .. vim.fn.fnamemodify(main, ":t")
            .. "-"
            .. branch:gsub("[/\\%s]", "-")
        vim.ui.input({ prompt = "Worktree path: ", default = default, completion = "dir" }, function(path)
            if path and path ~= "" then
                add(branch, normalize(vim.fn.expand(path)))
            end
        end)
    end

    if opts.branch and opts.branch ~= "" then
        ask_path(opts.branch)
        return
    end
    vim.ui.input({ prompt = "Branch: " }, function(branch)
        branch = branch and vim.trim(branch)
        if branch and branch ~= "" then
            ask_path(branch)
        end
    end)
end

local function delete_session(path)
    local ok, auto_session = pcall(require, "auto-session")
    if not ok then
        return
    end
    local lib = require("auto-session.lib")
    local session_file = auto_session.get_root_dir() .. lib.escape_session_name(path) .. ".vim"
    if vim.fn.filereadable(session_file) == 1 then
        auto_session.delete_session_file(session_file, path)
    end
end

local function remove(worktree, on_done)
    if worktree.main then
        notify("Refusing to remove the main worktree", vim.log.levels.WARN)
        return
    end
    if worktree.path == normalize(vim.fn.getcwd(-1, -1)) then
        notify("Switch to another worktree before removing this one", vim.log.levels.WARN)
        return
    end

    local display = vim.fn.fnamemodify(worktree.path, ":~")
    local function run(force)
        local args = { "worktree", "remove" }
        if force then
            table.insert(args, "--force")
        end
        table.insert(args, worktree.path)
        local ok, _, err = git(args)
        if ok then
            delete_session(worktree.path)
            notify("Removed worktree " .. display)
            if on_done then
                on_done()
            end
            return
        end
        if force then
            notify(err, vim.log.levels.ERROR)
            return
        end
        vim.ui.select({ "No", "Yes" }, {
            prompt = err .. "\nForce remove " .. display .. "?",
        }, function(choice)
            if choice == "Yes" then
                run(true)
            end
        end)
    end

    vim.ui.select({ "No", "Yes" }, { prompt = "Remove worktree " .. display .. "?" }, function(choice)
        if choice == "Yes" then
            run(false)
        end
    end)
end

local worktrees
worktrees = function(opts)
    opts = themes.get_dropdown(opts or {})
    local results = list_worktrees()
    if not results then
        return
    end

    local cwd = normalize(vim.fn.getcwd(-1, -1))
    local displayer = entry_display.create({
        separator = " ",
        items = {
            { width = 1 },
            { width = 30 },
            { remaining = true },
        },
    })

    pickers.new(opts, {
        prompt_title = "Git Worktrees",
        finder = finders.new_table({
            results = results,
            entry_maker = function(entry)
                local name = entry.branch or ("(" .. entry.head .. ")")
                local flags = {}
                if entry.main then
                    table.insert(flags, "main")
                end
                if entry.locked then
                    table.insert(flags, "locked")
                end
                if entry.prunable then
                    table.insert(flags, "prunable")
                end
                local path = vim.fn.fnamemodify(entry.path, ":~")
                if #flags > 0 then
                    path = path .. " [" .. table.concat(flags, ",") .. "]"
                end
                return {
                    value = entry,
                    ordinal = name .. " " .. entry.path,
                    display = function()
                        return displayer({
                            { entry.path == cwd and "*" or " ", "TelescopeResultsSpecialComment" },
                            { name, "TelescopeResultsIdentifier" },
                            { path, "TelescopeResultsComment" },
                        })
                    end,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                    switch(selection.value.path)
                end
            end)

            local create_worktree = function()
                local branch = action_state.get_current_line()
                actions.close(prompt_bufnr)
                create({ branch = branch })
            end

            local remove_worktree = function()
                local selection = action_state.get_selected_entry()
                if not selection then
                    return
                end
                actions.close(prompt_bufnr)
                remove(selection.value, function()
                    worktrees(opts)
                end)
            end

            map("i", "<C-a>", create_worktree)
            map("n", "<C-a>", create_worktree)
            map("i", "<C-d>", remove_worktree)
            map("n", "<C-d>", remove_worktree)
            return true
        end,
    }):find()
end

return require("telescope").register_extension({
    exports = {
        worktree = worktrees,
        worktrees = worktrees,
        create = create,
        switch = switch,
    },
})
