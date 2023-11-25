return {
  {
    "telescope.nvim",
    opts = {
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = { prompt_position = "top" },
        preview = { treesitter = false },
        mappings = {
          n = {
            l = "select_default",
          },
          i = {
            ["<C-l>"] = "select_default",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    },
  },
}
