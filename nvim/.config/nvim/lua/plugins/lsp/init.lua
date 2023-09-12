return {
	{ "williamboman/mason.nvim", cmd = "Mason", lazy = true, config = true },
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		lazy = true,
		config = function() require("lsp-zero.settings").preset({}) end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			local lsp = require("lsp-zero")

			for _, file in
				pairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/plugins/lsp/options", [[v:val =~ '\.lua$']]))
			do
				local server = file:gsub("%.lua$", "")
				lsp.configure(server, require("plugins.lsp.options." .. server))
			end

			lsp.on_attach(function(_, bufnr)
				lsp.default_keymaps({ buffer = bufnr })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
			end)
			lsp.set_sign_icons({ error = "", warn = "", hint = "", info = "" })
			lsp.skip_server_setup({ "tsserver", "rust_analyzer", "jdtls" })
			lsp.setup()
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
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		opts = function()
			local cmp = require("cmp")
			local cmp_action = require("lsp-zero.cmp").action()

			require("lsp-zero.cmp").extend()
			require("luasnip.loaders.from_vscode").lazy_load()

			return {
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
					["<tab>"] = cmp_action.luasnip_jump_forward(),
					["<S-tab>"] = cmp_action.luasnip_jump_backward(),
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
		event = "VeryLazy",
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
					builtins.formatting.gofmt,
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
