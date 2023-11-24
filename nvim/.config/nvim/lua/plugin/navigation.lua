return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				char = { enabled = false },
				search = { enabled = false },
			},
		},
		keys = {
			{ "s", function() require("flash").jump() end, mode = { "n", "x", "o" } },
			{ "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" } },
			{ "r", function() require("flash").remote() end, mode = "o" },
			{ "R", function() require("flash").treesitter_search() end, mode = { "o", "x" } },
		},
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
