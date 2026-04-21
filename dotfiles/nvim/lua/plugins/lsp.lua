return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "pyright", "gopls" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require "config/lspconfig"
    end,
  },
}
