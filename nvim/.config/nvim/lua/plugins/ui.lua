return {
	{
		"folke/tokyonight.nvim",
		event = "UIEnter",
		config = function() vim.cmd("colorscheme tokyonight") end,
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		event = "VeryLazy",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
		opts = { show_modified = true },
		keys = {
			{ "[[", function() require("barbecue.ui").navigate(-2) end },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				icons_enabled = false,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
			},
		},
	},
}
