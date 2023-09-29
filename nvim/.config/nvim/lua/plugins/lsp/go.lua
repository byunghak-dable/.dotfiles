return {
	"ray-x/go.nvim",
	ft = { "go", "gomod" },
	event = "CmdlineEnter",
	config = function()
		local augroup = vim.api.nvim_create_augroup("GoFormat", {})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function() require("go.format").goimport() end,
			group = augroup,
		})
		require("go").setup()
	end,
	build = function() require("go.install").update_all_sync() end,
}
