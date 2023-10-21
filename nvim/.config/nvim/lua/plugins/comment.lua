return {
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
		opts = function()
			return {
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
		end,
	},
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		keys = {
			{ "]t", function() require("todo-comments").jump_next() end },
			{ "[t", function() require("todo-comments").jump_prev() end },
			{ "<leader>ft", "<cmd>TodoTelescope<cr>" },
		},
		opts = {},
	},
}
