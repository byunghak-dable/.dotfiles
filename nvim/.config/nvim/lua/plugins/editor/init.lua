return {
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			scope = { show_start = false },
		},
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},
	{
		"echasnovski/mini.surround",
		event = "InsertEnter",
		opts = {
			mappings = {
				add = "gza",
				replace = "gzr",
				delete = "gzd",
				find = "gzf",
				find_left = "gzF",
				highlight = "gzh",
				update_n_lines = "gzn",
			},
		},
	},
	{
		"anuvyklack/windows.nvim",
		event = "VeryLazy",
		dependencies = "anuvyklack/middleclass",
		keys = {
			{ "<C-w>m", "<cmd>WindowsMaximize<cr>" },
			{ "<C-w>=", "<cmd>WindowsEqualize<cr>" },
		},
		opts = {},
	},
	{
		"echasnovski/mini.bufremove",
		keys = {
			{ "<A-w>", function() require("mini.bufremove").delete(0, false) end },
		},
	},
}
