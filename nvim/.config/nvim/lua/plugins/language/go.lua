return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts) table.insert(opts.ensure_installed, "golangci-lint") end,
  },
  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },
}
