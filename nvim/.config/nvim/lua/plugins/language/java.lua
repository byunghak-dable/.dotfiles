return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts) table.insert(opts.ensure_installed, "google-java-format") end,
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
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
