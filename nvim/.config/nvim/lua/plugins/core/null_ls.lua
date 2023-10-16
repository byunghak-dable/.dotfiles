return {
	"jose-elias-alvarez/null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "jay-babu/mason-null-ls.nvim", opts = { handlers = {} } },
	},
	opts = function()
		local builtins = require("null-ls").builtins
		local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

		vim.api.nvim_create_user_command(
			"DisableFormatting",
			function() vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 }) end,
			{ nargs = 0 }
		)

		return {
			sources = {
				builtins.code_actions.eslint,
				builtins.diagnostics.eslint,
				builtins.formatting.prettier,
			},
			on_attach = function(client, bufnr)
				if not client.supports_method("textDocument/formatting") then return end
				vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							bufnr = bufnr,
							filter = function(c) return c.name == "null-ls" end,
						})
					end,
				})
			end,
		}
	end,
}
