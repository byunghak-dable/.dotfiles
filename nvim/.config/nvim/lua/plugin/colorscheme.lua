vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		require("lazy").load({ plugins = { "onedark.nvim" } })
		vim.cmd.colorscheme("onedark")
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
}
