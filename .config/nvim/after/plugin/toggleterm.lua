---@diagnostic disable: deprecated
-- https://gist.github.com/ram535/b1b7af6cd7769ec0481eb2eed549ea23?permalink_comment_id=4230661#gistcomment-4230661

local api = vim.api
local fn = vim.fn
local opt = vim.opt

local terminal_window = nil
local terminal_buffer = nil
local terminal_job_id = nil

local function terminal_window_size()
    return tonumber(api.nvim_exec("echo &lines", true)) / 2
end

local function TerminalOpen()
    if fn.bufexists(terminal_buffer) == 0 then
        api.nvim_command("new lua_terminal")
        api.nvim_command("wincmd J")
        -- api.nvim_command("resize " .. terminal_window_size())
        terminal_job_id = fn.termopen(os.getenv("SHELL"), {
            detach = 1
        })
        api.nvim_command("silent file Terminal 1")
        terminal_window = fn.win_getid()
        terminal_buffer = fn.bufnr("%")
        opt.buflisted = false
    else
        if fn.win_gotoid(terminal_window) == 0 then
            api.nvim_command("sp")
            api.nvim_command("wincmd J")
            -- api.nvim_command("resize " .. terminal_window_size())
            api.nvim_command("buffer Terminal 1")
            terminal_window = fn.win_getid()
        end
    end
    vim.cmd("startinsert")
end

local function TerminalClose()
    if fn.win_gotoid(terminal_window) == 1 then
        api.nvim_command("hide")
    end
end

local function TerminalToggle()
    if fn.win_gotoid(terminal_window) == 1 then
        TerminalClose()
    else
        TerminalOpen()
    end
end

---@diagnostic disable-next-line: unused-local, unused-function
local function TerminalExec(cmd)
    if fn.win_gotoid(terminal_window) == 0 then
        TerminalOpen()
    end
    fn.jobsend(terminal_job_id, "clear\n")
    fn.jobsend(terminal_job_id, cmd .. "\n")
    api.nvim_command("normal! G")
    api.nvim_command("wincmd p")
end

local keymap = require("util").keymap

keymap({ "n", "t" }, "<C-t>", TerminalToggle)
