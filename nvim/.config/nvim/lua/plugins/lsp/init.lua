return {
	{ "williamboman/mason.nvim", cmd = "Mason", lazy = true, opts = {} },
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
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
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				keys = {
					{ "<tab>", function() require("luasnip").jump(1) end, mode = { "i", "s" } },
					{ "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
				},
				config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
			},
		},
		opts = function()
			local cmp = require("cmp")

			return {
				snippet = {
					expand = function(args) require("luasnip").lsp_expand(args.body) end,
				},
				sources = {
					{ name = "path" },
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "buffer" },
				},
				mapping = {
					["<C-space>"] = cmp.mapping.complete(),
					["<C-f>"] = cmp.mapping.confirm({ select = true }),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				experimental = { ghost_text = true },
			}
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "jay-babu/mason-null-ls.nvim", opts = { handlers = {} } },
		},
		opts = function()
			local builtins = require("null-ls").builtins
			local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

			vim.api.nvim_create_user_command(
				"DisableFormatting",
				function() vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 }) end,
				{ nargs = 0 }
			)

			return {
				sources = {
					builtins.code_actions.eslint,
					builtins.diagnostics.eslint,
					builtins.formatting.prettier,
				},
				on_attach = function(client, bufnr)
					if not client.supports_method("textDocument/formatting") then return end
					vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(c) return c.name == "null-ls" end,
							})
						end,
					})
				end,
			}
		end,
	},
}
