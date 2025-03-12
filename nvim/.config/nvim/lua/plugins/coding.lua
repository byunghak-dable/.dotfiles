return {
  {
    "nvim-lspconfig",
    keys = {
      { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    },
    opts = {
      inlay_hints = { enabled = true },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "gi", "gI", remap = true, desc = "Goto Implementation" }
      keys[#keys + 1] = { "<leader>rn", "<leader>cr", remap = true, desc = "Rename" }
    end,
  },
  {
    "nvim-dap",
    keys = {
      { "<leader>dx", function() require("dap").clear_breakpoints() end },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = function(_, opts)
      opts.keymap["<C-j>"] = { "select_next", "fallback" }
      opts.keymap["<C-k>"] = { "select_prev", "fallback" }
      opts.keymap["<C-u>"] = { "scroll_documentation_up", "fallback" }
      opts.keymap["<C-d>"] = { "scroll_documentation_down", "fallback" }
      opts.keymap["<C-f>"] = { "select_and_accept" }

      table.insert(opts.sources.default, 1, "avante")
      opts.sources.providers.avante = {
        module = "blink-cmp-avante",
        name = "Avante",
      }
    end,
  },
}
