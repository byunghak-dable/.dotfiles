return {
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
}
