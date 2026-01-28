return {
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        ["*"] = {
          keys = {
            { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },
            { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Goto Definition" },
            { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Goto Implementation" },
            { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename" },
          },
        },
      },
    },
  },
  {
    "nvim-dap",
    keys = {
      { "<leader>dx", function() require("dap").clear_breakpoints() end },
    },
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap["<C-j>"] = { "select_next", "fallback" }
      opts.keymap["<C-k>"] = { "select_prev", "fallback" }
      opts.keymap["<C-u>"] = { "scroll_documentation_up", "fallback" }
      opts.keymap["<C-d>"] = { "scroll_documentation_down", "fallback" }
      opts.keymap["<C-f>"] = { "select_and_accept" }
      opts.keymap["<Tab>"] = { "select_and_accept", "fallback" }
    end,
  },
}
