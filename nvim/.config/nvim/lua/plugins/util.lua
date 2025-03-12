return {
  {
    "echasnovski/mini.bufremove",
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
    "numToStr/Navigator.nvim",
    keys = {
      { "<C-k>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" }, desc = "Navigate Up" },
      { "<C-j>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" }, desc = "Navigator Down" },
      { "<C-h>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" }, desc = "Navigator Left" },
      { "<C-l>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" }, desc = "Navigator Right" },
      { "<C-p>", "<cmd>NavigatorPrevious<cr>", mode = { "n", "t" }, desc = "Navigator Previous" },
    },
    opts = { disable_on_zoom = true },
  },
}
