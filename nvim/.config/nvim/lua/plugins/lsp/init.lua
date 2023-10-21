return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- "williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
		},
		config = function()
			local lsp_conf = require("lspconfig")
			-- local mason_lsp = require("mason-lspconfig")
			local cmp_lsp = require("cmp_nvim_lsp")
			local float_conf = { border = "rounded" }

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_conf)
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_conf)
			vim.diagnostic.config({ float = float_conf })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buf_opts = { buffer = args.buf }

					vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts)
					vim.keymap.set("n", "go", vim.lsp.buf.type_definition, buf_opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, buf_opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, buf_opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, buf_opts)
					vim.keymap.set("n", "gl", vim.diagnostic.open_float, buf_opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, buf_opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, buf_opts)

					if vim.lsp.inlay_hint then
						vim.keymap.set("n", "<leader>sh", function() vim.lsp.inlay_hint(0, nil) end)
					end
				end,
			})
			lsp_conf.util.default_config.capabilities = cmp_lsp.default_capabilities()

			-- mason_lsp.setup({
			-- 	handlers = {
			-- 		function(server)
			-- 			local pcall, opts = pcall(require, "plugins.lsp.options." .. server)
			-- 			lsp_conf[server].setup(pcall and opts or {})
			-- 		end,
			-- 		tsserver = function() end,
			-- 		rust_analyzer = function() end,
			-- 		jdtls = function() end,
			-- 	},
			-- })
		end,
	},
	{
		"hinell/lsp-timeout.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.g["lsp-timeout-config"] = {
				stopTimeout = 60 * 1000,
				startTimeout = 1 * 1000,
				silent = false,
			}
		end,
	},
}
