return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = "williamboman/mason.nvim",
		lazy = true,
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "jsonls" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = "b0o/schemastore.nvim",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts, {
				settings = {
					json = {
						validate = { enable = true },
						schemas = require("schemastore").json.schemas(),
					},
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				json = { { "prettierd", "prettier" } },
			},
		},
	},
}
