return {
	"neovim/nvim-lspconfig",
	dependencies = "b0o/schemastore.nvim",
	opts = function(_, opts)
		return vim.tbl_deep_extend("force", opts, {
			settings = {
				yaml = {
					schemas = require("schemastore").yaml.schemas(),
				},
			},
		})
	end,
}
