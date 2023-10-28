return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"b0o/schemastore.nvim",
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = "williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(opts.ensure_installed, { "yamlls" })
			end,
		},
	},
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
