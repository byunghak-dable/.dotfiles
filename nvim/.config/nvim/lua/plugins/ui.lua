return {
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		event = "VeryLazy",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "[[", function() require("barbecue.ui").navigate(-2) end },
		},
		opts = { show_modified = true },
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
