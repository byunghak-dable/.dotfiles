return {
	{
		"AlexvZyl/nordic.nvim",
		event = "UIEnter",
		opts = {
			leap = { dim_backdrop = true },
		},
		config = function(_, opts)
			local nordic = require("nordic")
			nordic.setup(opts)
			nordic.load()
		end,
	},
}
