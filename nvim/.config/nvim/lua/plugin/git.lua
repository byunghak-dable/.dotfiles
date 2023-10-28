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

				vim.keymap.set("n", "]h", gs.next_hunk, buf_opts)
				vim.keymap.set("n", "[h", gs.prev_hunk, buf_opts)
				vim.keymap.set("n", "<leader>gp", gs.preview_hunk, buf_opts)
				vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, buf_opts)
				vim.keymap.set("n", "<leader>gB", function() gs.blame_line({ full = true }) end, buf_opts)
				vim.keymap.set("n", "<leader>gr", gs.reset_buffer, buf_opts)
			end,
		},
	},
}
