return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
			local themes = require("telescope.themes")
			local actions = require("telescope.actions")
			local fb_actions = telescope.extensions.file_browser.actions

			return {
				defaults = {
					path_display = { "smart" },
					sorting_strategy = "ascending",
					layout_strategy = "flex",
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
					["ui-select"] = { themes.get_cursor() },
					file_browser = {
						path = "%:p:h",
						cwd_to_path = true,
						hijack_netrw = true,
						hide_parent_dir = true,
						hidden = true,
						grouped = true,
						select_buffer = true,
						mappings = {
							n = { r = fb_actions.goto_cwd },
							i = {
								["<C-r>"] = fb_actions.goto_cwd,
								["<C-w>"] = function() vim.cmd("normal vbd") end,
							},
						},
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			}
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup(opts)
			telescope.load_extension("ui-select")
			telescope.load_extension("file_browser")
			pcall(telescope.load_extension, "fzf")

			vim.lsp.handlers["textDocument/definition"] = builtin.lsp_definitions
			vim.lsp.handlers["textDocument/implementation"] = builtin.lsp_implementations
			vim.lsp.handlers["textDocument/typeDefinition"] = builtin.lsp_type_definitions
			vim.lsp.handlers["textDocument/references"] = builtin.lsp_references
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{
				"antosha417/nvim-lsp-file-operations",
				dependencies = "nvim-lua/plenary.nvim",
				config = true,
			},
		},
		keys = {
			{ "<leader>e", "<cmd>NvimTreeFindFileToggle!<cr>" },
		},
		opts = function()
			local HEIGHT_RATIO = 0.9
			local WIDTH_RATIO = 0.5

			return {
				actions = {
					change_dir = { global = true },
				},
				diagnostics = {
					enable = true,
					show_on_dirs = true,
				},
				renderer = {
					group_empty = true,
					highlight_git = true,
					highlight_diagnostics = true,
				},
				view = {
					relativenumber = true,
					width = function() return math.floor(vim.opt.columns:get() * WIDTH_RATIO) end,
					float = {
						enable = true,
						open_win_config = function()
							local screen_w = vim.opt.columns:get()
							local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
							local window_w = screen_w * WIDTH_RATIO
							local window_h = screen_h * HEIGHT_RATIO
							local center_x = (screen_w - window_w) / 2
							local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

							return {
								border = "rounded",
								relative = "editor",
								row = center_y,
								col = center_x,
								width = math.floor(window_w),
								height = math.floor(window_h),
							}
						end,
					},
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					local bufopts = { buffer = bufnr }

					api.config.mappings.default_on_attach(bufnr)
					vim.keymap.set("n", "<c-t>", api.tree.change_root_to_node, bufopts)
					vim.keymap.set("n", "l", api.node.open.no_window_picker, bufopts)
					vim.keymap.set("n", "h", api.node.navigate.parent_close, bufopts)
				end,
			}
		end,
	},
}
