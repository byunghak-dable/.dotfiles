return {
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
		},
		config = function() require("leap").add_default_mappings(true) end,
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
