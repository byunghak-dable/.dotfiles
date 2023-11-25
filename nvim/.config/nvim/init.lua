-- bootstrap lazy.nvim, LazyVim and your plugins
local path = vim.fn.expand("%")

if vim.fn.isdirectory(path) ~= 0 then vim.fn.chdir(path) end

require("config.lazy")
