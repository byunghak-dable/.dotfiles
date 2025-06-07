return {
  {
    "olimorris/codecompanion.nvim",
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "codecompanion" } },
      {
        "folke/which-key.nvim",
        opts = {
          spec = {
            {
              mode = { "n", "v" },
              { "<leader>a", group = "+ai", icon = { icon = "ﮧ", hl = "false" } },
            },
          },
        },
      },
    },
    opts = {
      strategies = {
        chat = { adapter = "copilot", model = "claude-sonnet-4-20250514" },
        inline = { adapter = "copilot", model = "claude-sonnet-4-20250514" },
        cmd = { adapter = "copilot", model = "claude-sonnet-4-20250514" },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true,
            make_vars = true,
            make_slash_commands = true,
          },
        },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    build = "npm install -g mcp-hub@latest",
    opts = {},
  },
}
