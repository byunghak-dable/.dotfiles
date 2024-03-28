return {
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = { "kotlin" },
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
  {
    "nvim-treesitter-context",
    opts = { enable = false },
  },
}