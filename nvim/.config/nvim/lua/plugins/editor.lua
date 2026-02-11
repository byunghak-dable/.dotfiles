return {
  { "bufferline.nvim", enabled = false },
  {
    "lualine.nvim",
    opts = {
      options = { globalstatus = false },
    },
  },
  {
    "flash.nvim",
    opts = {
      modes = {
        char = { enabled = false },
        search = { enabled = false },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gf", "<cmd>DiffviewFileHistory<cr>", desc = "Diffvew" },
      { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview (cwd)" },
      { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
  },
  {
    "nvim-treesitter",
    opts = {
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
          swap_next = { ["<C-n>"] = "@parameter.inner" },
          swap_previous = { ["<C-p>"] = "@parameter.inner" },
        },
      },
    },
  },
  {
    "nvim-mini/mini.bufremove",
    keys = {
      { "<A-w>", "<leader>bd", remap = true, desc = "Delete Buffer" },
    },
  },
  {
    "anuvyklack/windows.nvim",
    dependencies = "anuvyklack/middleclass",
    keys = {
      { "<C-w>m", "<cmd>WindowsMaximize<cr>", desc = "Windows Maximize" },
      { "<C-w>=", "<cmd>WindowsEqualize<cr>", desc = "Windows Equalize" },
    },
    opts = {},
  },
  {
    "alexghergh/nvim-tmux-navigation",
    opts = { disable_when_zoomed = true },
    keys = {
      { "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", desc = "Navigate Left" },
      { "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", desc = "Navigate Down" },
      { "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", desc = "Navigate Up" },
      { "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", desc = "Navigate Right" },
    },
  },
}
