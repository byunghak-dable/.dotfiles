return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "stylua" })
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "lua_ls" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
					telemetry = { enable = false },
					hint = { enable = true },
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		-- optional = true,
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
}
