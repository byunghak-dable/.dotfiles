return {
	"mfussenegger/nvim-dap",
	dependencies = { "rcarriga/nvim-dap-ui", opts = {} },
	keys = {
		-- break
		{ "<leader>dp", function() require("dap").toggle_breakpoint() end },
		{ "<leader>dc", function() require("dap").clear_breakpoints() end },
		-- control
		{ "<leader>dn", function() require("dap").continue() end },
		{ "<leader>ds", function() require("dap").pause() end },
		{ "<leader>dt", function() require("dap").terminate() end },
		{ "<leader>dC", function() require("dap").run_to_cursor() end },
		-- move
		{ "<leader>dk", function() require("dap").up() end },
		{ "<leader>dj", function() require("dap").down() end },
		{ "<leader>di", function() require("dap").step_into() end },
		{ "<leader>do", function() require("dap").step_out() end },
		{ "<leader>dO", function() require("dap").step_over() end },
		{ "<leader>dg", function() require("dap").goto_() end },
		-- repl
		{ "<leader>dr", function() require("dap").repl.toggle() end },
		-- ui
		{ "<leader>du", function() require("dapui").toggle({}) end },
		{ "<leader>de", function() require("dapui").eval() end },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
		dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
		dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
	end,
}
