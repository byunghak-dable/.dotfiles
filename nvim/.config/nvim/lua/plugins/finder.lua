return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>fu", "<leader>fb", remap = true, desc = "Buffers" },
      {
        "<leader>e",
        function()
          Snacks.explorer({
            layout = {
              layout = { position = "bottom" },
            },
            auto_close = true,
            hidden = true,
            ignored = true,
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
      picker = {
        win = {
          input = {
            keys = {
              ["<C-l>"] = { "confirm", mode = { "i" } },
            },
          },
        },
      },
    },
  },
}
