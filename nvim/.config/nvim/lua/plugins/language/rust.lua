return {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
		{
			"williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				table.insert(opts.ensure_installed, "codelldb")
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(opts.ensure_installed, { "rust_analyzer" })
			end,
		},
	},
	opts = function()
		local rt = require("rust-tools")
		local rt_dap = require("rust-tools.dap")
		local debugger_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"

		return {
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "<leader>rh", rt.hover_actions.hover_actions, { buffer = bufnr })
					vim.keymap.set("n", "<leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })
				end,
			},
			dap = {
				adapter = rt_dap.get_codelldb_adapter(
					debugger_path .. "adapter/codelldb",
					vim.fn.has("mac") == 1 and debugger_path .. "lldb/lib/liblldb.dylib"
				),
			},
			tools = {
				hover_actions = { auto_focus = true },
				inlay_hints = { auto = false },
			},
		}
	end,
}
