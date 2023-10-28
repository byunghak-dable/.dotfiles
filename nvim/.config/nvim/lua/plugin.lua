local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		path,
	})
end
vim.opt.rtp:prepend(path)

require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.core" },
	{ import = "plugins.language" },
}, {
	change_detection = { notify = false },
	ui = { border = "rounded" },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"man",
			},
		},
	},
})

local term_size = { width = 0.9, height = 0.9 }

vim.keymap.set("n", "<leader>gg", function() require("lazy.util").float_term({ "lazygit" }, { size = term_size }) end)
vim.keymap.set(
	"n",
	"<leader>gG",
	function() require("lazy.util").float_term({ "lazygit" }, { cwd = vim.fn.expand("%:p:h"), size = term_size }) end
)
