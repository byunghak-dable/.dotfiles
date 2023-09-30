return {
	{
		"echasnovski/mini.bufremove",
		keys = {
			{ "<A-w>", function() require("mini.bufremove").delete(0, false) end },
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
		"numToStr/Navigator.nvim",
		opts = { disable_on_zoom = true },
		keys = {
			{ "<A-k>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" } },
			{ "<A-j>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" } },
			{ "<A-h>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" } },
			{ "<A-l>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" } },
			{ "<A-p>", "<cmd>NavigatorPrevious<cr>", mode = { "n", "t" } },
		},
	},
}
