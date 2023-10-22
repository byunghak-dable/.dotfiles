return {
	"williamboman/mason.nvim",
	cmd = "Mason",
	build = ":MasonUpdate",
	lazy = true,
	config = function(_, opts)
		local mason = require("mason")
		local registry = require("mason-registry")

		mason.setup(opts)

		for _, tool in ipairs(opts.ensure_installed or {}) do
			local package = registry.get_package(tool)
			if not package:is_installed() then package:install() end
		end
	end,
}
