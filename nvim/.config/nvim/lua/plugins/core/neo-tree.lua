return {
  "neo-tree.nvim",
  keys = {
    {
      "<leader>e",
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
        ["p"] = {
          function(state) require("neo-tree.ui.renderer").focus_node(state, state.tree:get_node():get_parent_id()) end,
          desc = "focus parent",
        },
      },
    },
    filesystem = {
      hijack_netrw_behavior = "disabled",
    },
  },
}
