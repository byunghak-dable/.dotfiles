return {
	"neovim/nvim-lspconfig",
	opts = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
}
