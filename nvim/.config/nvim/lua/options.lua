-- columns
vim.opt.number = true
vim.opt.relativenumber = true
-- tabs & indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
-- line wrapping
vim.opt.wrap = false
-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- appearance
vim.opt.pumheight = 10
vim.opt.cmdheight = 1
vim.opt.numberwidth = 2
-- vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
-- split
vim.opt.splitbelow = true
vim.opt.splitright = true
-- file config
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.undofile = true
vim.opt.swapfile = false
-- etc
vim.opt.cursorline = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.clipboard:append("unnamedplus")
