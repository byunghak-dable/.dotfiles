return {
  {
    "telescope.nvim",
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
            -- ["<C-t>"] = function() end,
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
      {
        "<leader>fe",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd_to_path = true,
            respect_gitignore = false,
            hide_parent_dir = true,
            hidden = true,
            no_ignore = true,
            grouped = true,
            select_buffer = true,
            initial_mode = "normal",
          })
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local lazy_util = require("lazyvim.util")
      local fb_utils = require("telescope._extensions.file_browser.utils")
      local fb_actions = telescope.extensions.file_browser.actions

      for _, name in pairs({ "rename_buf", "rename_dir_buf" }) do
        local rename_func = fb_utils[name]

        fb_utils[name] = function(old_path, new_path)
          rename_func(old_path, new_path)
          lazy_util.lsp.on_rename(old_path, new_path)
        end
      end

      telescope.setup({
        extensions = {
          file_browser = {
            mappings = {
              n = {
                h = fb_actions.goto_parent_dir,
              },
            },
          },
        },
      })
      telescope.load_extension("file_browser")
    end,
    init = function()
      local path = vim.fn.expand("%")

      if vim.fn.isdirectory(path) ~= 0 then vim.fn.chdir(path) end
    end,
  },
}
