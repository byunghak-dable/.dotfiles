return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "yaml-language-server" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = "b0o/schemastore.nvim",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts, {
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
							validate = true,
							schemaStore = require("schemastore").yaml.schemas(),
						},
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
