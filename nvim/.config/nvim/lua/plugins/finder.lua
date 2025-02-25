return {
  {
    "neo-tree.nvim",
    keys = {
      {
        "<leader>fe",
        function() require("neo-tree.command").execute({ toggle = true, reveal = true }) end,
        desc = "Explorer NeoTree",
      },
    },
    opts = {
      window = {
        position = "float",
        mappings = {
          ["/"] = "noop",
          ["z"] = "noop",
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
      filesystem = { hijack_netrw_behavior = "disabled" },
    },
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader><space>", "<leader>fF", remap = true, desc = "Find Files (cwd)" },
      { "<leader>/", "<leader>sG", remap = true, desc = "Grep (cwd)" },
      { "<leader>fu", "<leader>fb", remap = true, desc = "Buffers" },
    },
    opts = function(_, opts)
      local fzf = require("fzf-lua")
      local config = fzf.config

      opts.winopts.width = 0.9
      opts.winopts.height = 0.9
      opts.files.actions = {}

      config.defaults.keymap.fzf["ctrl-d"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-u"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-d>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-u>"] = "preview-page-up"
    end,
  },
}
