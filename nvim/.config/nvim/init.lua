require("options")
require("keymaps")
require("plugin")

local path = vim.fn.expand("%")
if vim.fn.isdirectory(path) == 0 then return end
vim.fn.chdir(path)
vim.cmd.bd()
