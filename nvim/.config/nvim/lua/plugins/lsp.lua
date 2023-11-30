return {
  {
    "nvim-lspconfig",
    dependencies = {
      "smjonas/inc-rename.nvim",
      opts = {},
    },
    keys = {
      { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    },
    opts = {
      servers = {
        tsserver = {
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "relative",
              importModuleSpecifierEnding = "minimal",
            },
          },
        },
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "gi", "gI", remap = true, desc = "Goto Implementation" }
      keys[#keys + 1] = { "<leader>rn", "<leader>cr", remap = true, desc = "Rename" }
    end,
  },
}
