return {
  { "bufferline.nvim", enabled = false },
  { "dashboard-nvim", enabled = false },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = "SmiteshP/nvim-navic",
    opts = {
      show_modified = true,
    },
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
    "nvim-treesitter",
    opts = {
      highlight = {
        disable = function(_, buf)
          local filesize_limit = 10000 * 1024
          local _, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

          return stats and stats.size > filesize_limit
        end,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
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
}
