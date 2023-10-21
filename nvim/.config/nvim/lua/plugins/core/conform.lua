return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "stylua" })
		end,
	},
	opts = {
		formatters_by_ft = {
			javascript = { { { "prettierd", "prettier" } } },
			typescript = { { "prettierd", "prettier" } },
			javascriptreact = { { "prettierd", "prettier" } },
			typescriptreact = { { "prettierd", "prettier" } },
			svelte = { { "prettierd", "prettier" } },
			css = { { "prettierd", "prettier" } },
			html = { { "prettierd", "prettier" } },
			json = { { "prettierd", "prettier" } },
			yaml = { { "prettierd", "prettier" } },
			markdown = { { "prettierd", "prettier" } },
			lua = { "stylua" },
			python = { "black" },
			go = { "goimports", "gofumpt" },
			rust = { "rustfmt" },
			java = { "google-java-format" },
		},
		format_on_save = {
			async = false,
		},
	},
}
