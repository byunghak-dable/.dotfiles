return {
	{
		"folke/tokyonight.nvim",
		event = "UIEnter",
		config = function() vim.cmd("colorscheme tokyonight") end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = "MunifTanjim/nui.nvim",
		opts = {
			messages = { view_search = false },
			lsp = {
				hover = { enabled = false },
				signature = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
		},
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		event = "VeryLazy",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
		opts = { show_modified = true },
		keys = {
			{ "[[", function() require("barbecue.ui").navigate(-2) end },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			local ts_comment = require("ts_context_commentstring.integrations.comment_nvim")
			require("Comment").setup({ pre_hook = ts_comment.create_pre_hook() })
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
		config = true,
	},
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
				local gs = package.loaded.gitsigns
				vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, { buffer = bufnr })
			end,
		},
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
		"echasnovski/mini.bufremove",
		keys = {
			{ "<A-w>", function() require("mini.bufremove").delete(0, false) end },
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
	{
		"anuvyklack/windows.nvim",
		event = "VeryLazy",
		dependencies = "anuvyklack/middleclass",
		keys = {
			{ "<C-w>m", "<cmd>WindowsMaximize<cr>" },
			{ "<C-w>=", "<cmd>WindowsEqualize<cr>" },
		},
		config = true,
	},
	{
		"numToStr/Navigator.nvim",
		opts = { disable_on_zoom = true },
		keys = {
			{ "<A-k>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" } },
			{ "<A-j>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" } },
			{ "<A-h>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" } },
			{ "<A-l>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" } },
			{ "<A-p>", "<cmd>NavigatorPrevious<cr>", mode = { "n", "t" } },
		},
	},
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "kevinhwang91/nvim-hlslens", event = "InsertEnter", config = true },
	{ "lukas-reineke/indent-blankline.nvim", event = "VeryLazy", opts = { show_current_context = true } },
	{ "ggandor/leap.nvim", event = "VeryLazy", config = function() require("leap").add_default_mappings(true) end },
}
