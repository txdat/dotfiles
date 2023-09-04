if vim.loader then
    vim.loader.enable()
end
if not vim.uv then
    vim.uv = vim.loop
end

pcall(require, "config")

-- skip loading plugins in vscode
if not vim.g.vscode then
    pcall(require, "plugins")
end
