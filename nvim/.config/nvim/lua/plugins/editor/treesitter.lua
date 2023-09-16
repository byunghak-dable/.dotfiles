return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "VeryLazy",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		{ "nvim-treesitter/nvim-treesitter-context", config = true },
	},
	opts = {
		ensure_installed = "all",
		autotag = { enable = true },
		highlight = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["ap"] = "@parameter.outer",
					["ip"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]C"] = "@class.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[C"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<C-n>"] = "@parameter.inner",
				},
				swap_previous = {
					["<C-p>"] = "@parameter.inner",
				},
			},
		},
	},
	config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
}
