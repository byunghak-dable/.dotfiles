return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tsserver = {
        keys = {
          {
            "<leader>oi",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.organizeImports.ts" }, diagnostics = {} },
              })
            end,
            desc = "Organize Imports",
          },
          {
            "<leader>ru",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Remove Unused",
          },
          {
            "<leader>ri",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnusedImports.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Remove Unused Imports",
          },
          {
            "<leader>mi",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.addMissingImports.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Add Missig Imports",
          },
        },
      },
    },
  },
}
