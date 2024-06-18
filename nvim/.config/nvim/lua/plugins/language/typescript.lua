return {
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
    -- NOTE: code actions
    -- <leader>co : Organize Imports
    -- <leader>cu : Remove Unused
    -- <leader>cM : Add Missing Imports
  },
}
