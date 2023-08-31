if vim.loader then
    vim.loader.enable()
end

pcall(require, "config")

-- skip loading plugins in vscode
if not vim.g.vscode then
    pcall(require, "plugins")
end
