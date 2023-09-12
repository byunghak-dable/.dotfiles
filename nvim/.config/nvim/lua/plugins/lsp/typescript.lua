return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	keys = {
		{ "<leader>mi", "<cmd>TSToolsAddMissingImports<cr>" },
		{ "<leader>oi", "<cmd>TSToolsOrganizeImports<cr>" },
		{ "<leader>si", "<cmd>TSToolsSortImports<cr>" },
		{ "<leader>ri", "<cmd>TSToolsRemoveUnusedImports<cr>" },
		{ "<leader>fa", "<cmd>TSToolsFixAll<cr>" },
		{ "gs", "<cmd>TSToolsGoToSourceDefinition<cr>" },
	},
	opts = function()
		return {
			settings = {
				separate_diagnostic_server = false,
				tsserver_file_preferences = {
					importModuleSpecifierPreference = "relative",
				},
			},
		}
	end,
}
