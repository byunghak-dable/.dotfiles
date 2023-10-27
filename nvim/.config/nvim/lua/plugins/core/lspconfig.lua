return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = "williamboman/mason.nvim",
			opts = {
				ensure_installed = {
					"lua_ls",
					"tsserver",
					"jsonls",
					"yamlls",
					"dockerls",
					"docker_compose_language_service",
				},
				handlers = {
					function(server)
						local plugin = require("lazy.core.config").spec.plugins["nvim-lspconfig"]
						local opts = require("lazy.core.plugin").values(plugin, "opts", false)

						require("lspconfig")[server].setup(opts)
					end,
					tsserver = function() end,
					rust_analyzer = function() end,
					jdtls = function() end,
				},
			},
		},
		{
			"hinell/lsp-timeout.nvim",
			config = function()
				vim.g["lsp-timeout-config"] = {
					stopTimeout = 60 * 1000,
					startTimeout = 1 * 1000,
					silent = false,
				}
			end,
		},
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_lsp = require("cmp_nvim_lsp")

		lspconfig.util.default_config.capabilities = cmp_lsp.default_capabilities()
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
	end,
}
