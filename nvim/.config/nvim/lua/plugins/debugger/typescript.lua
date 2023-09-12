return {
	"mfussenegger/nvim-dap",
	opts = function()
		local dap = require("dap")
		local ok, debug = pcall(require("mason-registry").get_package, "js-debug-adapter")

		if not ok then return end
		if not dap.adapters["pwa-node"] then
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { debug:get_install_path() .. "/js-debug/src/dapDebugServer.js", "${port}" },
				},
			}
		end

		for _, language in pairs({ "typescript", "javascript" }) do
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
}
