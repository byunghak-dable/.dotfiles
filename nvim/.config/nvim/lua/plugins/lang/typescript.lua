return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tsserver = {
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "relative",
            importModuleSpecifierEnding = "minimal",
          },
        },
      },
    },
  },
}
