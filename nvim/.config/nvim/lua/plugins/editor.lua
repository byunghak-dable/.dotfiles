return {
  {
    "nvim-treesitter",
    opts = {
      textobjects = {
        swap = {
          enable = true,
          swap_next = {
            ["<C-n>"] = "@parameter.inner",
          },
          swap_previous = {
            ["<C-p>"] = "@parameter.inner",
          },
        },
      },
    },
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.mapping = {
        ["<C-space>"] = cmp.mapping.complete(),
        ["<C-f>"] = cmp.mapping.confirm({ select = true }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      }
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
    dependencies = "SmiteshP/nvim-navic",
    opts = { show_modified = true },
  },
}
