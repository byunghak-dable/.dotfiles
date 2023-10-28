return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "markdownlint", "marksman" })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				markdown = { { "prettierd", "prettier" } },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				markdown = { "markdownlint" },
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function() vim.fn["mkdp#util#install"]() end,
	},
}
