return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts) vim.list_extend(opts.ensure_installed, { "htmlhint", "html-lsp", "css-lsp" }) end,
  },
  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        html = { "htmlhint" },
      },
    },
  },
}
