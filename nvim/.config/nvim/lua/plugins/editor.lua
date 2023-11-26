return {
  {
    "noice.nvim",
    opts = {
      presets = {
        bottom_search = false,
        command_palette = false,
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    lazy = true,
    opts = {},
  },
  {
    "numToStr/Navigator.nvim",
    keys = {
      { "<A-k>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" }, desc = "Navigate Up" },
      { "<A-j>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" }, desc = "Navigator Down" },
      { "<A-h>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" }, desc = "Navigator Left" },
      { "<A-l>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" }, desc = "Navigator Right" },
      { "<A-p>", "<cmd>NavigatorPrevious<cr>", mode = { "n", "t" }, desc = "Navigator Previous" },
    },
    opts = { disable_on_zoom = true },
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
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gf", "<cmd>DiffviewFileHistory<cr>", desc = "Diffvew" },
      { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview (cwd)" },
      { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
  },
}
