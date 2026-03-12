--vim.loader.enable()

if vim.g.vscode then
    -- VSCode extension
else
    require("environment")
    require("config")
end
