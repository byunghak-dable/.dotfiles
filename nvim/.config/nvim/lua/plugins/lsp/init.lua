return {
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
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim", cmd = "Mason", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
		},
		config = function()
			local lspconf = require("lspconfig")
			local mason_lsp = require("mason-lspconfig")
			local cmp_lsp = require("cmp_nvim_lsp")
			local border_conf = { border = "rounded" }

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_conf)
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_conf)
			vim.diagnostic.config({ float = border_conf })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }

					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				end,
			})
			lspconf.util.default_config.capabilities = cmp_lsp.default_capabilities()

			mason_lsp.setup({
				handlers = {
					function(server)
						local pcall, opts = pcall(require, "plugins.lsp.options." .. server)
						lspconf[server].setup(pcall and opts or {})
					end,
					tsserver = function() end,
					rust_analyzer = function() end,
					jdtls = function() end,
				},
			})
		end,
	},
}
