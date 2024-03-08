return {
  {
    "nvim-lspconfig",
    keys = {
      { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    },
    opts = {
      servers = {
        tsserver = { mason = false },
        kotlin_language_server = {},
      },
      setup = {
        tsserver = function() return true end,
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "gi", "gI", remap = true, desc = "Goto Implementation" }
      keys[#keys + 1] = { "<leader>rn", "<leader>cr", remap = true, desc = "Rename" }
    end,
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
    "mfussenegger/nvim-jdtls",
    opts = {
      jdtls = function(opts)
        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
        local jvmArg = "-javaagent:" .. install_path .. "/lombok.jar"

        table.insert(opts.cmd, "--jvm-arg=" .. jvmArg)

        return opts
      end,
    },
  },
}
