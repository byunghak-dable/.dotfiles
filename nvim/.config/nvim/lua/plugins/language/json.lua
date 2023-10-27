return {
	"neovim/nvim-lspconfig",
	dependencies = "b0o/schemastore.nvim",
	opts = function(_, opts)
		return vim.tbl_deep_extend("force", opts, {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})
	end,
}
