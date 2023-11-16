return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-file-browser.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "antosha417/nvim-lsp-file-operations", opts = {} },
	},
	keys = {
		{ "<leader>fe", "<cmd>Telescope file_browser<cr>" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>" },
		{ "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>" },
		{ "<leader>fl", "<cmd>Telescope live_grep<cr>" },
		{ "<leader>fL", "<cmd>Telescope live_grep hidden=true no_ignore=true<cr>" },
		{ "<leader>fu", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<cr>" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>" },
		{ "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find<cr>" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<cr>" },
		{ "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>" },
		{ "<leader>fD", "<cmd>Telescope diagnostics<cr>" },
	},
	opts = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local fb_actions = telescope.extensions.file_browser.actions
		local fb_utils = require("telescope._extensions.file_browser.utils")
		local lf_operation = require("lsp-file-operations.will-rename")

		local function sync_import(old_path, new_path)
			local paths = vim.split(vim.fn.glob(new_path .. "*"), "\n")

			for _, new_name in pairs(paths) do
				local old_name = old_path .. new_name:sub(string.len(new_path) + 1)

				if vim.fn.isdirectory(new_name) ~= 0 then
					sync_import(old_name .. "/", new_name .. "/")
				else
					lf_operation.callback({ old_name = old_name, new_name = new_name })
				end
			end
		end

		for _, name in pairs({ "rename_buf", "rename_dir_buf" }) do
			local rename_func = fb_utils[name]

			fb_utils[name] = function(old_path, new_path)
				rename_func(old_path, new_path)
				sync_import(old_path, new_path)
			end
		end

		return {
			defaults = {
				path_display = { "smart" },
				sorting_strategy = "ascending",
				layout_strategy = "flex",
				preview = { treesitter = false },
				layout_config = {
					prompt_position = "top",
					width = 0.9,
					height = 0.9,
					vertical = { preview_height = 0.4 },
				},
				mappings = {
					n = { l = "select_default" },
					i = {
						["<C-l>"] = "select_default",
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<A-d>"] = actions.delete_buffer,
					},
				},
			},
			extensions = {
				file_browser = {
					path = "%:p:h",
					cwd_to_path = true,
					hide_parent_dir = true,
					hidden = true,
					grouped = true,
					select_buffer = true,
					mappings = {
						i = {
							["<C-r>"] = fb_actions.goto_cwd,
							["<C-w>"] = function() vim.cmd("normal vbd") end,
							["<A-d>"] = fb_actions.remove,
						},
					},
				},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup(opts)
		telescope.load_extension("file_browser")
		pcall(telescope.load_extension, "fzf")

		vim.lsp.handlers["textDocument/definition"] = builtin.lsp_definitions
		vim.lsp.handlers["textDocument/implementation"] = builtin.lsp_implementations
		vim.lsp.handlers["textDocument/typeDefinition"] = builtin.lsp_type_definitions
		vim.lsp.handlers["textDocument/references"] = builtin.lsp_references
	end,
}
