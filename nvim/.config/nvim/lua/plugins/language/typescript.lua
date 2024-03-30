return {
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        tsserver = { mason = false },
      },
      setup = {
        tsserver = function() return true end,
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
  {
    "neotest",
    dependencies = {
      "haydenmeade/neotest-jest",
    },
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
        })
      )
    end,
  },
}
