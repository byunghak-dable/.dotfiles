return {
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = true,
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
