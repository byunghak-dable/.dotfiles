return {
	"mfussenegger/nvim-dap-python",
	dependencies = "williamboman/mason.nvim",
	keys = {
		{ "<leader>tm", function() require("dap-python").test_method() end },
		{ "<leader>tc", function() require("dap-python").test_class() end },
	},
	opts = function()
		local path = require("mason-registry").get_package("debugpy"):get_install_path()

		return path .. "/venv/bin/python"
	end,
}
