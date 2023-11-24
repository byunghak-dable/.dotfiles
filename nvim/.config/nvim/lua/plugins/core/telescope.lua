return {
  {
    "telescope.nvim",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find Files (no hidden)" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>fL", "<cmd>Telescope live_grep hidden=true no_ignore=true<cr>", desc = "Grep (no hidden)" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics (Buffer)" },
      { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics (File)" },
      { "<leader>fu", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<cr>", desc = "Buffers" },
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
          n = { l = "select_default" },
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
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = "telescope.nvim",
    keys = {
      { "<leader>fe", "<cmd>Telescope file_browser<cr>" },
    },
    opts = function()
      local fb_actions = require("telescope._extensions.file_browser.actions")
      local fb_utils = require("telescope._extensions.file_browser.utils")
      local lazy_util = require("lazyvim.util")

      for _, name in pairs({ "rename_buf", "rename_dir_buf" }) do
        local rename_func = fb_utils[name]

        fb_utils[name] = function(old_path, new_path)
          rename_func(old_path, new_path)
          lazy_util.lsp.on_rename(old_path, new_path)
        end
      end

      return {
        extensions = {
          file_browser = {
            path = "%:p:h",
            cwd_to_path = true,
            hide_parent_dir = true,
            hidden = true,
            no_ignore = true,
            grouped = true,
            select_buffer = true,
            mappings = {
              i = {
                ["<C-r>"] = fb_actions.goto_cwd,
                ["<C-w>"] = function()
                  vim.cmd("normal vbd")
                end,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")

      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
    init = function()
      local path = vim.fn.expand("%")

      if type(path) == "string" and vim.fn.isdirectory(path) ~= 0 then
        vim.fn.chdir(path)
      end
    end,
  },
}
