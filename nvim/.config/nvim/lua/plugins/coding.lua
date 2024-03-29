return {
  {
    "nvim-lspconfig",
    keys = {
      { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "gi", "gI", remap = true, desc = "Goto Implementation" }
      keys[#keys + 1] = { "<leader>rn", "<leader>cr", remap = true, desc = "Rename" }
    end,
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.mapping = cmp.mapping.preset.insert({
        ["<C-f>"] = cmp.mapping.confirm({ select = true }),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-j>"] = cmp.mapping.select_next_item({ select = false, behavior = cmp.SelectBehavior.Select }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ select = false, behavior = cmp.SelectBehavior.Select }),
      })
    end,
  },
  {
    "flash.nvim",
    opts = {
      modes = {
        char = { enabled = false },
        search = { enabled = false },
      },
    },
  },
}
