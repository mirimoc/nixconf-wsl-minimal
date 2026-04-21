# nixconf-wsl-minimal

Minimales home-manager Flake für WSL2/Ubuntu. Enthält nur die wichtigsten CLI-Tools:

- **zsh** mit Powerlevel10k, Autocomplete, Fast-Syntax-Highlighting
- **tmux** mit Catppuccin-Theme und Resurrect
- **neovim** mit [LazyVim](https://www.lazyvim.org/)-Config
- **direnv** + nix-direnv
- **fd**, **bat**, **jq**

Kein Desktop, keine GUI-Pakete, keine Secrets. Bewusst schlank gehalten.

## Voraussetzungen

- WSL2 mit Ubuntu (oder anderer Linux-Distro)
- Nix installiert (Single-User reicht). Empfehlung: [Determinate Systems Installer](https://install.determinate.systems/)
- Flakes aktiviert (beim Determinate-Installer default, sonst in `~/.config/nix/nix.conf`):
  ```
  experimental-features = nix-command flakes
  ```

## Installation

```bash
# Repo klonen (kein GitHub-Login nötig, da public)
git clone https://github.com/mirimoc/nixconf-wsl-minimal ~/dotfiles
cd ~/dotfiles

# Falls dein WSL-Username nicht 'mirimoc' ist:
# flake.nix öffnen und `username = "mirimoc"` anpassen

# Aktivieren
nix run home-manager/master -- switch --flake .#wsl

# zsh als Default-Shell setzen
chsh -s $(which zsh)
```

Beim ersten Start von zsh läuft `p10k configure` automatisch durch — dort das gewünschte Prompt-Design auswählen.

## Anpassen

- **Username**: `flake.nix` → `username = "..."`
- **Pakete**: `home/development.nix` oder `home/nvim.nix` um `home.packages` / `extraPackages` ergänzen
- **zsh-Aliase**: `home/zsh.nix` → `shellAliases`
- **Eigene Module**: Neue Datei unter `home/`, in `home/wsl.nix` importieren

## Updaten

```bash
cd ~/dotfiles
nix flake update
home-manager switch --flake .#wsl
```

## Uninstallation

```bash
home-manager generations
home-manager remove-generations <ids...>
```

## Struktur

```
nixconf-wsl-minimal/
├── flake.nix              # Inputs (nixpkgs, home-manager) + Output
├── home/
│   ├── wsl.nix            # Top-Level-Modul, importiert alle anderen
│   ├── base.nix           # stateVersion, EDITOR
│   ├── zsh.nix            # zsh + p10k + Plugins + Aliase
│   ├── tmux.nix           # tmux + Catppuccin + Resurrect
│   ├── nvim.nix           # neovim + LSPs + Formatter
│   └── development.nix    # direnv + fd/bat/jq
└── dotfiles/
    └── nvim/              # LazyVim Lua-Config
```

## Hinweise

- **Git**: Nicht via Nix verwaltet. Entweder Ubuntu's `apt install git` nutzen oder eigenes Modul ergänzen.
- **tmux-sessionizer**: Das tmux-Keybinding `prefix + C-f` erwartet `~/.local/bin/tmux-sessionizer`. Wenn nicht vorhanden, Keybinding ignorieren oder Skript installieren (z.B. von [ThePrimeagen](https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer)).
- **LazyVim**: Erste Neovim-Starts dauern länger, da Plugins geladen werden. `:Lazy` zeigt den Status.
