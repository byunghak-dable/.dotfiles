return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			css = { { "prettierd", "prettier" } },
			html = { { "prettierd", "prettier" } },
		},
	},
	config = function(_, opts)
		local conform = require("conform")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

		conform.setup(opts)

		vim.api.nvim_create_user_command(
			"DisableFormatting",
			function() vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 }) end,
			{ nargs = 0 }
		)
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf

				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function() conform.format({ bufnr = bufnr }) end,
				})
			end,
		})
	end,
}
