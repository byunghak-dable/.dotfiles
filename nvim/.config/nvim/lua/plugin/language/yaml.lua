return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = "williamboman/mason.nvim",
		lazy = true,
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "yamlls" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = "b0o/schemastore.nvim",
		opts = function(_, opts)
			return vim.tbl_extend("force", opts.settings, {
				settings = {
					yaml = {
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				yaml = { { "prettierd", "prettier" } },
			},
		},
	},
}
