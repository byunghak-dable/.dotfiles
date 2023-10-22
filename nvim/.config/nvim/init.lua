require("options")
require("keymaps")
require("plugin")

local path = vim.fn.expand("%")
if type(path) == "string" and vim.fn.isdirectory(path) ~= 0 then vim.fn.chdir(path) end
