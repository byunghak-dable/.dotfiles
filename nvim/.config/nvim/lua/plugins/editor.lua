return {
  {
    "nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.mapping["<C-f>"] = cmp.mapping.confirm({ select = true })
      opts.mapping["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      opts.mapping["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    end,
  },
  {
    "flash.nvim",
    opts = {
      modes = {
        char = { enabled = false },
        search = { enabled = false },
      },
    },
  },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = "SmiteshP/nvim-navic",
    opts = {
      show_modified = true,
    },
  },
}
