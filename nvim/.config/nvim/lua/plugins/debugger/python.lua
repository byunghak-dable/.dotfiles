return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-python",
		keys = {
			{ "<leader>tm", function() require("dap-python").test_method() end },
			{ "<leader>tc", function() require("dap-python").test_class() end },
		},
		config = function()
			local path = require("mason-registry").get_package("debugpy"):get_install_path()
			require("dap-python").setup(path .. "/venv/bin/python")
		end,
	},
}
