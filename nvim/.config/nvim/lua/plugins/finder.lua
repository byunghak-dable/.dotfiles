return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader><space>", "<leader>fF", remap = true, desc = "Find Files (cwd)" },
      { "<leader>/", "<leader>sG", remap = true, desc = "Grep (cwd)" },
      { "<leader>fu", "<leader>fb", remap = true, desc = "Buffers" },
      {
        "<leader>e",
        function()
          Snacks.explorer({
            layout = {
              preview = true,
              layout = { position = "bottom" },
            },
            auto_close = true,
          })
        end,
        desc = "File Explorer",
      },
    },
    opts = {
      scroll = { enabled = false },
      explorer = {
        replace_netrw = false, -- Replace netrw with the snacks explorer
      },
    },
  },
}
