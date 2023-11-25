return {
  "neo-tree.nvim",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          reveal_file = vim.fn.expand("%:p"),
          reveal_force_cwd = true,
        })
      end,
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
      hijack_netrw_behavior = "disabled",
    },
  },
}
