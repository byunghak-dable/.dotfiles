return {
  "neo-tree.nvim",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          reveal_file = vim.fn.expand("%:p"),
          reveal = true,
        })
      end,
      desc = "Explorer NeoTree",
    },
  },
  opts = {
    window = {
      position = "float",
      mappings = {
        ["/"] = "noop",
        ["l"] = "open",
        ["h"] = "close_node",
        ["<C-h>"] = "navigate_up",
      },
    },
    filesystem = {
      bind_to_cwd = true,
      hijack_netrw_behavior = "disabled",
    },
  },
}
