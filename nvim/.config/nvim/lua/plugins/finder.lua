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
            -- disabling lazyvim "trouble" keymap
            ["<c-t>"] = false,
            ["<a-t>"] = false,
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = "telescope.nvim",
    keys = {
      { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
    },
    opts = {
      path = "%:p:h",
      cwd_to_path = true,
      hide_parent_dir = true,
      hidden = true,
      grouped = true,
      select_buffer = true,
      mappings = {
        i = {
          ["<C-w>"] = function() vim.cmd("normal vbd") end,
        },
      },
    },
    config = function(_, opts)
      local fb_utils = require("telescope._extensions.file_browser.utils")
      local lazy_util = require("lazyvim.util")

      for _, name in pairs({ "rename_buf", "rename_dir_buf" }) do
        local rename_func = fb_utils[name]

        fb_utils[name] = function(old_path, new_path)
          rename_func(old_path, new_path)
          lazy_util.lsp.on_rename(old_path, new_path)
        end
      end

      require("telescope._extensions.file_browser.config").setup(opts)
    end,
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
