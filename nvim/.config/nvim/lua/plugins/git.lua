return {
	{
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>" },
			{ "<leader>go", "<cmd>DiffviewOpen<cr>" },
			{ "<leader>gc", "<cmd>DiffviewClose<cr>" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			current_line_blame_opts = { delay = 100 },
			on_attach = function(bufnr)
				local buf_opts = { buffer = bufnr }
				local gs = package.loaded.gitsigns

				vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, buf_opts)
			end,
		},
	},
}
