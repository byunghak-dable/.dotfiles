return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"kristijanhusak/vim-dadbod-completion",
		{
			"L3MON4D3/LuaSnip",
			dependencies = "rafamadriz/friendly-snippets",
			keys = {
				{
					"<tab>",
					function() return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>" end,
					expr = true,
					silent = true,
					mode = "i",
				},
				{ "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
				{ "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
			},
			config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
		},
	},
	opts = function()
		local cmp = require("cmp")

		return {
			snippet = {
				expand = function(args) require("luasnip").lsp_expand(args.body) end,
			},
			sources = {
				{ name = "path" },
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "buffer" },
				{ name = "vim-dadbod-completion" },
			},
			mapping = {
				["<C-space>"] = cmp.mapping.complete(),
				["<C-f>"] = cmp.mapping.confirm({ select = true }),
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			experimental = { ghost_text = true },
		}
	end,
}
