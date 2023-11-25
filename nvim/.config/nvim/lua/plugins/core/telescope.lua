return {
  {
    "telescope.nvim",
    keys = {
      { "<leader><space>", "<leader>fF", desc = "Find Files (cwd)", remap = true },
      { "<leader>/", "<leader>sG", desc = "Grep (cwd)", remap = true },
    },
    opts = {
      defaults = {
        path_display = { "smart" },
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        preview = { treesitter = false },
        layout_config = {
          prompt_position = "top",
          width = 0.9,
          height = 0.9,
          vertical = { preview_height = 0.4 },
        },
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
