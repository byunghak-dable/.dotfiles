return {
  {
    "xTacobaco/cursor-agent.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      vim.keymap.set("n", "<leader>ca", ":CursorAgent<CR>", { desc = "Cursor Agent: Toggle terminal" })
      vim.keymap.set("v", "<leader>ca", ":CursorAgentSelection<CR>", { desc = "Cursor Agent: Send selection" })
      vim.keymap.set("n", "<leader>cA", ":CursorAgentBuffer<CR>", { desc = "Cursor Agent: Send buffer" })
    end,
  },
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>aC", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude Code Continue" },
    },
    opts = {
      window = {
        split_ratio = 0.4,
        position = "vertical",
      },
    },
  },
}
