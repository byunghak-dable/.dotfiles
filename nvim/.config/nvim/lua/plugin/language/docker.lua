return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "hadolint" })
		end,
	},
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				dockerfile = { "hadolint" },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			settings = {
				dockerls = {},
				docker_compose_language_service = {},
			},
		},
	},
}
