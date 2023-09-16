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
		config = true,
	},
}
