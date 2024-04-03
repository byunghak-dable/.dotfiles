return {
  {
    "mini.bufremove",
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
      { "<A-k>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" }, desc = "Navigate Up" },
      { "<A-j>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" }, desc = "Navigator Down" },
      { "<A-h>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" }, desc = "Navigator Left" },
      { "<A-l>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" }, desc = "Navigator Right" },
      { "<A-p>", "<cmd>NavigatorPrevious<cr>", mode = { "n", "t" }, desc = "Navigator Previous" },
    },
    opts = {
      disable_on_zoom = true,
    },
  },
}
