return {
  {
    "neo-tree.nvim",
    keys = {
      {
        "<leader>fe",
        function() require("neo-tree.command").execute({ toggle = true, reveal = true }) end,
        desc = "Explorer NeoTree",
      },
    },
    opts = {
      window = {
        position = "float",
        mappings = {
          ["/"] = "noop",
          ["l"] = "open",
          ["h"] = "close_node",
          ["<C-h>"] = "navigate_up",
        },
      },
      filesystem = {
        hijack_netrw_behavior = "disabled",
      },
    },
  },
  {
    "telescope.nvim",
    keys = {
      { "<leader><space>", "<leader>fF", remap = true, desc = "Find Files (cwd)" },
      { "<leader>/", "<leader>sG", remap = true, desc = "Grep (cwd)" },
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
    dependencies = "telescope.nvim",
    keys = {
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo History" },
    },
    config = function() require("telescope").load_extension("undo") end,
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = "telescope.nvim",
    keys = {
      {
        "<leader>fw",
        function() require("telescope").extensions.git_worktree.git_worktrees() end,
        desc = "Git Wortrees",
      },
      {
        "<leader>fW",
        function() require("telescope").extensions.git_worktree.create_git_worktree() end,
        desc = "Create Git Worktree",
      },
    },
    config = function(_, opts)
      require("git-worktree").setup(opts)
      require("telescope").load_extension("git_worktree")
    end,
  },
}
