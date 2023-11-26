return {
  {
    "telescope.nvim",
    keys = {
      { "<leader><space>", "<leader>fF", desc = "Find Files (cwd)", remap = true },
      { "<leader>/", "<leader>sG", desc = "Grep (cwd)", remap = true },
    },
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
  {
    "debugloop/telescope-undo.nvim",
    keys = {
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo History" },
    },
    config = function() require("telescope").load_extension("undo") end,
  },
}
