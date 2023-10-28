return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			css = { { "prettierd", "prettier" } },
			html = { { "prettierd", "prettier" } },
		},
		format_on_save = {
			async = false,
		},
	},
}
