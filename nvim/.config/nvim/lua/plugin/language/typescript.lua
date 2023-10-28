return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = "williamboman/mason.nvim",
		lazy = true,
		opts = function(_, opts)
			opts.handlers = vim.tbl_extend("force", opts.handlers, { tsserver = function() end })
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "tsserver" })
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		keys = {
			{ "<leader>mi", "<cmd>TSToolsAddMissingImports<cr>" },
			{ "<leader>oi", "<cmd>TSToolsOrganizeImports<cr>" },
			{ "<leader>si", "<cmd>TSToolsSortImports<cr>" },
			{ "<leader>ri", "<cmd>TSToolsRemoveUnusedImports<cr>" },
			{ "<leader>fa", "<cmd>TSToolsFixAll<cr>" },
			{ "gs", "<cmd>TSToolsGoToSourceDefinition<cr>" },
		},
		opts = function()
			return {
				settings = {
					separate_diagnostic_server = false,
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "all",
						includeInlayEnumMemberValueHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeCompletionsForModuleExports = true,
						importModuleSpecifierPreference = "relative",
					},
				},
			}
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(opts.ensure_installed, { "js-debug-adapter" })
			end,
		},
		opts = function()
			local dap = require("dap")
			if not dap.adapters["pwa-node"] then
				require("dap").adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						args = {
							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
								.. "/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
				if not dap.configurations[language] then
					dap.configurations[language] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
					}
				end
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(opts.ensure_installed, { "stylua" })
			end,
		},
		opts = {
			formatters_by_ft = {
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				javascript = { "eslint" },
				typescript = { "eslint" },
				javascriptreact = { "eslint" },
				typescriptreact = { "eslint" },
				svelte = { "eslint" },
			},
		},
	},
}
