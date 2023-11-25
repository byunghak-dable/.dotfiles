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
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame_opts = { delay = 100 },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Git Blame" })
      end,
    },
  },
}
