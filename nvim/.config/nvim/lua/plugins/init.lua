return {
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "]r", function() require("illuminate").goto_next_reference(false) end },
			{ "[r", function() require("illuminate").goto_prev_reference(false) end },
		},
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts) require("illuminate").configure(opts) end,
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
		},
		config = function() require("leap").add_default_mappings(true) end,
	},
	{
		"echasnovski/mini.surround",
		keys = function()
			local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
			local opts = require("lazy.core.plugin").values(plugin, "opts", false)

			return {
				{ opts.mappings.add, mode = { "n", "v" } },
				{ opts.mappings.delete },
				{ opts.mappings.replace },
			}
		end,
		opts = {
			mappings = {
				add = "gza",
				delete = "gzd",
				replace = "gzr",
			},
		},
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},
}
