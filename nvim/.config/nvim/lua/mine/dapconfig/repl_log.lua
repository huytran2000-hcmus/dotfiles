-- Makes the dap REPL usable for program logs: colors log lines (output arrives as plain text,
-- no ANSI colors), soft wraps, and adds `]e` / `[e` (error jump)
local M = {}

local ns = vim.api.nvim_create_namespace("mine.dap_repl_log")

-- Level tokens, checked in order; `line` colors the whole line instead of only the token
local levels = {
    { word = "FATAL",   hl = "DiagnosticError", line = true },
    { word = "SEVERE",  hl = "DiagnosticError", line = true },
    { word = "ERROR",   hl = "DiagnosticError", line = true },
    { word = "WARNING", hl = "DiagnosticWarn" },
    { word = "WARN",    hl = "DiagnosticWarn" },
    { word = "INFO",    hl = "DiagnosticOk" },
    { word = "DEBUG",   hl = "Comment" },
    { word = "TRACE",   hl = "Comment" },
}

local function mark(buf, row, col, end_col, hl)
    vim.api.nvim_buf_set_extmark(buf, ns, row, col, {
        end_col = end_col,
        hl_group = hl,
        ephemeral = true,
        priority = 200,
    })
end

local function highlight_line(buf, row, line)
    -- Java stack frames and "... 23 more"
    if line:match("^%s+at ") or line:match("^%s+%.%.%. %d+ more") then
        mark(buf, row, 0, #line, "Comment")
        return
    end

    -- Go panics and uncaught exceptions
    if line:match("^panic:") or line:match("^goroutine %d+") or line:match("^Exception in thread")
        or line:match("^Caused by:") or line:match("^[%w%.$]+Exception[:%s]") then
        mark(buf, row, 0, #line, "DiagnosticError")
        return
    end

    -- Leading timestamp, e.g. 2026-10-09 12:00:00.123 or 2026-10-09T12:00:00.123+0700
    local _, ts_end = line:find("^%d%d%d%d%-%d%d%-%d%d[T ][%d:%.]+[%+%-%dZ]*")
    if ts_end then
        mark(buf, row, 0, ts_end, "Comment")
    end

    -- Level token near the start of the line, case-insensitive (ERROR, error, "level":"error")
    local head = line:sub(1, 160):lower()
    for _, level in ipairs(levels) do
        local s, e = head:find("%f[%w]" .. level.word:lower() .. "%f[%W]")
        if s then
            if level.line then
                mark(buf, row, ts_end or 0, #line, level.hl)
            else
                mark(buf, row, s - 1, e, level.hl)
            end
            return
        end
    end
end

local error_pattern = [[\c\v<(ERROR|FATAL|SEVERE)>|^panic:|^Caused by:|^Exception in thread]]

local function setup_repl_buffer(buf)
    local opts = { buffer = buf, silent = true }
    vim.keymap.set("n", "]e", function()
        vim.fn.search(error_pattern, "W")
    end, vim.tbl_extend("force", opts, { desc = "Next error line" }))
    vim.keymap.set("n", "[e", function()
        vim.fn.search(error_pattern, "bW")
    end, vim.tbl_extend("force", opts, { desc = "Previous error line" }))
end

function M.setup()
    local group = vim.api.nvim_create_augroup("mine.dap_repl", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "dap-repl",
        callback = function(args)
            setup_repl_buffer(args.buf)
        end,
    })
    -- nvim-dap forces wrap=false on its own window; soft wrap keeps long log lines readable
    vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
        group = group,
        callback = function(args)
            if vim.bo[args.buf].filetype ~= "dap-repl" then
                return
            end
            -- dap-ui/nvim-dap set their window options after this event
            vim.schedule(function()
                local win = vim.fn.bufwinid(args.buf)
                if win ~= -1 then
                    vim.wo[win].wrap = true
                    vim.wo[win].linebreak = true
                end
            end)
        end,
    })

    vim.api.nvim_set_decoration_provider(ns, {
        on_win = function(_, _, buf)
            return vim.bo[buf].filetype == "dap-repl"
        end,
        on_line = function(_, _, buf, row)
            local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
            if line and line ~= "" then
                highlight_line(buf, row, line)
            end
        end,
    })
end

return M
