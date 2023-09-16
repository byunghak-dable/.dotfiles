return {
	{
		"folke/tokyonight.nvim",
		event = "UIEnter",
		config = function() vim.cmd("colorscheme tokyonight") end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = "MunifTanjim/nui.nvim",
		opts = {
			messages = { view_search = false },
			lsp = {
				hover = { enabled = false },
				signature = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
		},
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
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
			},
		},
	},
}
