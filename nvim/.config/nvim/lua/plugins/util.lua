return {
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
}
