local lualine = require("lualine")

-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = "#080808",
    fg       = "#b2b2b2",
    yellow   = "#e3c78a",
    cyan     = "#79dac8",
    darkblue = "#394b70",
    green    = "#8cc85f",
    orange   = "#ff9e64",
    violet   = "#cf87e8",
    magenta  = "#ff5189",
    blue     = "#80a0ff",
    red      = "#ff5454",
    white    = "#c6c6c6",
}

-- auto change color according to neovims mode
local mode_color = {
    n = colors.red,
    i = colors.green,
    v = colors.blue,
    [""] = colors.blue,
    V = colors.blue,
    c = colors.magenta,
    no = colors.red,
    s = colors.orange,
    S = colors.orange,
    [""] = colors.orange,
    ic = colors.yellow,
    R = colors.violet,
    Rv = colors.violet,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ["r?"] = colors.cyan,
    ["!"] = colors.red,
    t = colors.red,
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- local dap_components = {
--     "dapui_watches",
--     "dapui_breakpoints",
--     "dapui_scopes",
--     "dapui_console",
--     "dapui_stacks",
--     "dap-repl",
-- }

-- Config
local config = {
    options = {
        -- Disable sections and component separators
        component_separators = "",
        section_separators = "",
        globalstatus = true,
        -- disabled_filetypes = dap_components,
        -- ignore_focus = dap_components,
        theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

-- ins_left {
--     function()
--         return "▌"
--     end,
--     -- color = { fg = colors.blue },
--     color = function()
--         return { fg = mode_color[vim.fn.mode()] }
--     end,
--     padding = { right = 1 },
-- }

ins_left {
    -- mode component
    function()
        -- return "󰝥"
        return "<" .. vim.fn.mode():upper() .. ">"
    end,
    color = function()
        return { fg = mode_color[vim.fn.mode()] }
    end,
}

ins_left {
    "filename",
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta },
    file_status = true,
    symbols = {
        modified = "󰝥",
        readonly = "",
        unnamed = "",
        newfile = "",
    },
    -- fmt = function(filename)
    --     if #filename > 80 then
    --         filename = vim.fs.basename(filename)
    --     end
    --     if #filename > 80 then
    --         return string.sub(filename, #filename - 80, #filename)
    --     end
    --     return filename
    -- end
}

-- ins_left {
--     -- filesize component
--     "filesize",
--     cond = conditions.buffer_not_empty,
-- }

ins_left { "location" }

ins_left { "progress" }

ins_left {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    update_in_insert = true,
    sections = { "warn", "error" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    -- diagnostics_color = {
    --     color_error = { fg = colors.red },
    --     color_warn = { fg = colors.yellow },
    --     color_info = { fg = colors.cyan },
    --     color_hint = { fg = colors.white },
    -- },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it"s any number greater then 2
-- ins_left {
--     function()
--         return "%="
--     end,
-- }

-- ins_left {
--     -- Lsp server name .
--     function()
--         local msg = "No Active Lsp"
--         local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
--         local clients = vim.lsp.get_active_clients()
--         if next(clients) == nil then
--             return msg
--         end
--         for _, client in ipairs(clients) do
--             local filetypes = client.config.filetypes
--             if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
--                 return client.name
--             end
--         end
--         return msg
--     end,
--     icon = " LSP:",
--     color = { fg = colors.fg },
-- }

-- Add components to right sections
-- ins_right {
--     "o:encoding", -- option component same as &encoding in viml
--     fmt = string.upper,
--     cond = conditions.hide_in_width,
--     color = { fg = colors.green },
-- }
--
-- ins_right {
--     "fileformat",
--     fmt = string.upper,
--     icons_enabled = false, -- I think icons are cool but Eviline doesn"t have them. sigh
--     color = { fg = colors.green },
-- }

ins_right {
    "diff",
    -- Is it me or the symbol for modified us really weird
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
}

ins_right {
    "branch",
    icon = "",
    color = { fg = colors.violet },
}

-- ins_right {
--     function()
--         return "▐"
--     end,
--     -- color = { fg = colors.blue },
--     color = function()
--         return { fg = mode_color[vim.fn.mode()] }
--     end,
--     padding = { left = 1 },
-- }

-- Now don"t forget to initialize lualine
lualine.setup(config)
