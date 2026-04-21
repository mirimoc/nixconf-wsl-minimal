# Neovim Configuration

Diese Neovim-Konfiguration nutzt einen **Hybrid-Ansatz** mit Nix + lazy.nvim:

## Hybrid-Ansatz

- **Via Nix managed:**
  - Neovim selbst
  - LSP Servers (lua_ls, nil_ls, pyright, gopls, rust-analyzer, tsserver)
  - Formatters (stylua, black, nixpkgs-fmt, gofumpt)
  - Treesitter Grammars (vorcompiliert, keine Build-Zeit!)
  - CLI Tools (ripgrep, fd, lazygit)

- **Via lazy.nvim managed:**
  - Alle Neovim-Plugins
  - Plugin-Updates
  - Lazy loading

## Struktur

```
dotfiles/nvim/
├── init.lua              # Entry point, lädt lazy.nvim
├── lua/
│   ├── config/
│   │   ├── options.lua   # Vim options
│   │   ├── keymaps.lua   # Keybindings
│   │   ├── autocmds.lua  # Autocommands
│   │   ├── lazy.lua      # lazy.nvim setup
│   │   └── nix.lua       # (auto-generated) Nix treesitter path
│   └── plugins/
│       ├── colorscheme.lua  # catppuccin-frappe
│       ├── obsidian.lua     # Obsidian vault integration
│       ├── auto-save.lua    # Auto-save on changes
│       ├── telescope.lua    # Fuzzy finder
│       ├── treesitter.lua   # Syntax highlighting
│       ├── lsp.lua          # LSP configuration
│       ├── cmp.lua          # Completion
│       └── ui.lua           # UI plugins (lualine, neo-tree, which-key)
```

## Wichtige Keybindings

- **Leader:** `<Space>`
- **Files:** `<leader>ff` (find files), `<leader>fg` (grep)
- **Explorer:** `<leader>e` (toggle neo-tree)
- **LSP:** `gd` (definition), `gr` (references), `K` (hover), `<leader>ca` (code action)
- **Buffers:** `<S-h>` (prev), `<S-l>` (next)
- **Obsidian:** `<leader>on` (new note), `<leader>oo` (open note), `<leader>os` (search), `<leader>ot` (today)

## Neue Plugins hinzufügen

Einfach eine neue Datei in `lua/plugins/` erstellen:

```lua
return {
  {
    "author/plugin-name",
    opts = {},
  },
}
```

## Treesitter Grammars hinzufügen

In `home/common/nvim.nix` die Grammar zur Liste hinzufügen:

```nix
treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
  # ... existing
  p.newlanguage
]));
```

## LSP Server hinzufügen

1. In `home/common/nvim.nix` den LSP Server zu `extraPackages` hinzufügen
2. In `lua/plugins/lsp.lua` den Server zu `opts.servers` hinzufügen

## Updates

- **Nix packages:** `darwin-rebuild switch --flake .`
- **Neovim plugins:** `:Lazy update` in Neovim
