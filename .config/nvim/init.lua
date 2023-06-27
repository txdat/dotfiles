pcall(require, "config")

-- skip loading plugins in vscode
if not vim.g.vscode then
    pcall(require, "plugins")
end
