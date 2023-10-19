return {
	"AlexvZyl/nordic.nvim",
	opts = {
		leap = { dim_backdrop = true },
	},
	config = function(_, opts)
		local nordic = require("nordic")
		nordic.setup(opts)
		nordic.load()
	end,
}
