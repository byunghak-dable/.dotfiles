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
			local p = registry.get_package(tool)
			if not p:is_installed() then p:install() end
		end
	end,
}
