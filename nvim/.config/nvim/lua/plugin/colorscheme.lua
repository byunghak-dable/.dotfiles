vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		require("lazy").load({ plugins = { "gruvbox-material" } })
		vim.cmd.colorscheme("gruvbox-material")
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
		"sainnhe/gruvbox-material",
		lazy = true,
		config = function() vim.g.gruvbox_material_float_style = "dim" end,
	},
}
