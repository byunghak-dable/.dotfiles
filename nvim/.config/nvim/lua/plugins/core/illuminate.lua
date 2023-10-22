return {
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
	config = function(_, opts)
		require("illuminate").configure(opts)

		for _, suffix in pairs({ "Text", "Read", "Write" }) do
			vim.api.nvim_set_hl(0, "IlluminatedWord" .. suffix, { bg = "#444c56" })
		end
	end,
}
