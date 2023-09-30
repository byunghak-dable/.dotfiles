return {
	"ray-x/go.nvim",
	ft = { "go", "gomod" },
	event = "CmdlineEnter",
	opts = {},
	build = function() require("go.install").update_all_sync() end,
}
