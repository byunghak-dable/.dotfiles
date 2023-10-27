return {
	"neovim/nvim-lspconfig",
	opts = {
		settings = {
			yaml = {
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	},
}
