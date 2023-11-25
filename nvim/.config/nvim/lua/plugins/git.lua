return {
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffvew" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview (cwd)" },
      { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
  },
}
