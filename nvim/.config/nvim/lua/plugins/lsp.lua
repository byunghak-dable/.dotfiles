return {
  {
    "nvim-lspconfig",
    dependencies = {
      {
        "nvim-java/nvim-java",
        dependencies = {
          "nvim-java/lua-async-await",
          "nvim-java/nvim-java-core",
          "nvim-java/nvim-java-test",
          "nvim-java/nvim-java-dap",
          "MunifTanjim/nui.nvim",
          "mfussenegger/nvim-dap",
        },
      },
      {
        "pmizio/typescript-tools.nvim",
        opts = {
          settings = {
            expose_as_code_action = "all",
            separate_diagnostic_server = false,
            tsserver_file_preferences = {
              includeCompletionsForModuleExports = true,
              importModuleSpecifierPreference = "relative",
            },
          },
        },
      },
    },
    keys = {
      { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    },
    opts = {
      servers = {
        tsserver = { mason = false },
      },
      setup = {
        tsserver = function() return true end,
        jdtls = function() require("java").setup() end,
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "gi", "gI", remap = true, desc = "Goto Implementation" }
      keys[#keys + 1] = { "<leader>rn", "<leader>cr", remap = true, desc = "Rename" }
    end,
  },
}
