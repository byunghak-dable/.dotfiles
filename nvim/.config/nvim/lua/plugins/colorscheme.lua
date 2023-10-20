return {
	{
		"AlexvZyl/nordic.nvim",
		event = "UIEnter",
		enabled = false,
		opts = {
			leap = { dim_backdrop = true },
		},
		config = function(_, opts)
			local nordic = require("nordic")
			nordic.setup(opts)
			nordic.load()
		end,
	},
	{
		"navarasu/onedark.nvim",
		event = "UIEnter",
		opts = {
			style = "warmer",
		},
		config = function(_, opts)
			local onedark = require("onedark")
			onedark.setup(opts)
			onedark.load()
		end,
	},
}
