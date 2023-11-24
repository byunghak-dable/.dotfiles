vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		require("lazy").load({ plugins = { "solarized-osaka.nvim" } })
		vim.cmd.colorscheme("solarized-osaka")
	end,
})

return {
	{
		"AlexvZyl/nordic.nvim",
		lazy = true,
		opts = {
			leap = { dim_backdrop = true },
		},
	},
	{
		"navarasu/onedark.nvim",
		lazy = true,
		opts = {
			style = "warmer",
		},
	},
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
	},
}
