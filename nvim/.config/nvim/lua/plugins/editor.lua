return {
  {
    "RRethy/vim-illuminate",
    keys = {
      {
        "]r",
        function()
          require("illuminate").goto_next_reference(false)
        end,
      },
      {
        "[r",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<A-w>",
        function()
          require("mini.bufremove").delete(0, false)
        end,
      },
    },
  },
  {
    "numToStr/Navigator.nvim",
    opts = { disable_on_zoom = true },
    keys = {
      { "<A-k>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" } },
      { "<A-j>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" } },
      { "<A-h>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" } },
      { "<A-l>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" } },
      { "<A-p>", "<cmd>NavigatorPrevious<cr>", mode = { "n", "t" } },
    },
  },
  {
    "anuvyklack/windows.nvim",
    event = "VeryLazy",
    dependencies = "anuvyklack/middleclass",
    keys = {
      { "<C-w>m", "<cmd>WindowsMaximize<cr>" },
      { "<C-w>=", "<cmd>WindowsEqualize<cr>" },
    },
    opts = {},
  },
}
