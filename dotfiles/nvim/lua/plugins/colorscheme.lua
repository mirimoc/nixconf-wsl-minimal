return {
  -- Colorscheme: Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "frappe",  -- latte, frappe, macchiato, mocha
      transparent_background = true,
      no_bold = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd([[colorscheme catppuccin-frappe]])
    end,
  },
}