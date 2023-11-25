return {
  {
    "noice.nvim",
    opts = {
      presets = {
        bottom_search = false,
        command_palette = false,
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    lazy = true,
    opts = {},
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = "VeryLazy",
    dependencies = "SmiteshP/nvim-navic",
    opts = {
      show_modified = true,
    },
  },
}
