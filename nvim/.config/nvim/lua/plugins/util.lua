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
    "mrjones2014/smart-splits.nvim",
    keys = {
      {
        "<A-k>",
        mode = { "n", "t" },
        function() require("smart-splits").move_cursor_up() end,
      },
      {
        "<A-j>",
        function() require("smart-splits").move_cursor_down() end,
        mode = { "n", "t" },
        desc = "Navigator Down",
      },
      {
        "<A-h>",
        function() require("smart-splits").move_cursor_left() end,
        mode = { "n", "t" },
        desc = "Navigator Left",
      },
      {
        "<A-l>",
        function() require("smart-splits").move_cursor_right() end,
        desc = "Navigator Right",
      },
      {
        "<A-p>",
        function() require("smart-splits").move_cursor_previous() end,
        desc = "Navigator Previous",
      },
    },
  },
}
