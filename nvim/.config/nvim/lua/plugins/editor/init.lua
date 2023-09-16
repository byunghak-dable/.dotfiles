return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"kevinhwang91/nvim-hlslens",
		event = "InsertEnter",
		config = true,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		opts = { show_current_context = true },
	},
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			large_file_cutoff = 2000,
			large_file_overrides = { providers = { "lsp" } },
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			for _, suffix in pairs({ "Text", "Read", "Write" }) do
				vim.api.nvim_set_hl(0, "IlluminatedWord" .. suffix, { bg = "#444c56" })
			end
		end,
		keys = {
			{ "]r", function() require("illuminate").goto_next_reference(false) end },
			{ "[r", function() require("illuminate").goto_prev_reference(false) end },
		},
	},
	{
		"echasnovski/mini.surround",
		event = "InsertEnter",
		opts = {
			mappings = {
				add = "gza",
				replace = "gzr",
				delete = "gzd",
				find = "gzf",
				find_left = "gzF",
				highlight = "gzh",
				update_n_lines = "gzn",
			},
		},
	},
}
