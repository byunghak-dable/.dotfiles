return {
  {
    "RRethy/vim-illuminate",
    keys = {
      { "]r", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference" },
      { "[r", function() require("illuminate").goto_prev_reference(false) end, desc = "Previous Reference" },
    },
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      { "<A-w>", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
    },
  },
  {
    "numToStr/Navigator.nvim",
    opts = { disable_on_zoom = true },
    keys = {
      { "<A-k>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" }, desc = "Navigate Up" },
      { "<A-j>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" }, desc = "Navigator Down" },
      { "<A-h>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" }, desc = "Navigator Left" },
      { "<A-l>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" }, desc = "Navigator Right" },
      { "<A-p>", "<cmd>NavigatorPrevious<cr>", mode = { "n", "t" }, desc = "Navigator Previous" },
    },
  },
  {
    "anuvyklack/windows.nvim",
    dependencies = "anuvyklack/middleclass",
    keys = {
      { "<C-w>m", "<cmd>WindowsMaximize<cr>", "Windows Maximize" },
      { "<C-w>=", "<cmd>WindowsEqualize<cr>", "Windows Equalize" },
    },
    opts = {},
  },
}
