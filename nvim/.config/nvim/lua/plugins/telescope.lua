return {
  {
    "telescope.nvim",
    keys = {
      { "<leader><space>", "<leader>fF", remap = true, desc = "Find Files (cwd)" },
      { "<leader>/", "<leader>sG", remap = true, desc = "Grep (cwd)" },
      { "<leader>fu", "<leader>fb", remap = true, desc = "Buffers" },
    },
    opts = {
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = {
          prompt_position = "top",
          width = 0.9,
          height = 0.9,
          preview_cutoff = 120,
        },
        preview = { treesitter = false },
        mappings = {
          n = {
            l = "select_default",
          },
          i = {
            ["<C-l>"] = "select_default",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<A-d>"] = "delete_buffer",
            ["<ESC>"] = "close",
          },
        },
      },
      pickers = {
        find_files = {
          follow = true,
        },
      },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = "telescope.nvim",
    keys = {
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo History" },
    },
    config = function() require("telescope").load_extension("undo") end,
  },
}
