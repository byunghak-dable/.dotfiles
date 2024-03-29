return {
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = { "kotlin" },
    },
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        kotlin = { "ktlint" },
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        kotlin_language_server = {},
      },
    },
  },
}
