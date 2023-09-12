return {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
	opts = function()
		local rt = require("rust-tools")
		local ok, codelldb = pcall(require("mason-registry").get_package, "codelldb")
		local debugger_path = ok and codelldb:get_install_path() .. "/extension/" or nil

		return {
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "<leader>rh", rt.hover_actions.hover_actions, { buffer = bufnr })
					vim.keymap.set("n", "<leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })
				end,
			},
			dap = {
				adapter = debugger_path and require("rust-tools.dap").get_codelldb_adapter(
					debugger_path .. "adapter/codelldb",
					vim.fn.has("mac") == 1 and debugger_path .. "lldb/lib/liblldb.dylib"
				) or nil,
			},
			tools = {
				hover_actions = { auto_focus = true },
			},
		}
	end,
}
