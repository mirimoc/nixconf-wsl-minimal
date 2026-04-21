# nixconf-wsl-minimal

Minimal home-manager flake for WSL2/Ubuntu. Contains only the essentials:

- **zsh** with Powerlevel10k, autocomplete, fast-syntax-highlighting
- **tmux** with Catppuccin theme and resurrect
- **neovim** with [LazyVim](https://www.lazyvim.org/) config
- **direnv** + nix-direnv
- **fd**, **bat**, **jq**

No desktop, no GUI packages, no secrets. Intentionally lean.

## Prerequisites

- WSL2 with Ubuntu (or any other Linux distro)
- Nix installed (single-user is enough). Recommended: [Determinate Systems installer](https://install.determinate.systems/)
- Flakes enabled (default with the Determinate installer, otherwise add to `~/.config/nix/nix.conf`):
  ```
  experimental-features = nix-command flakes
  ```

## Installation

```bash
# Clone (no GitHub auth needed, repo is public)
git clone https://github.com/mirimoc/nixconf-wsl-minimal ~/dotfiles
cd ~/dotfiles

# If your WSL username is not 'mirimoc':
# open flake.nix and adjust `username = "mirimoc"`

# Activate
nix run home-manager/master -- switch --flake .#wsl

# Make zsh the default shell
chsh -s $(which zsh)
```

On the first zsh launch, `p10k configure` will run — pick your preferred prompt style there.

## Customize

- **Username**: `flake.nix` → `username = "..."`
- **Packages**: extend `home.packages` / `extraPackages` in `home/development.nix` or `home/nvim.nix`
- **zsh aliases**: `home/zsh.nix` → `shellAliases`
- **Your own modules**: create a new file under `home/`, import it in `home/wsl.nix`

## Update

```bash
cd ~/dotfiles
nix flake update
home-manager switch --flake .#wsl
```

## Uninstall

```bash
home-manager generations
home-manager remove-generations <ids...>
```

## Layout

```
nixconf-wsl-minimal/
├── flake.nix              # inputs (nixpkgs, home-manager) + output
├── home/
│   ├── wsl.nix            # top-level module, imports the rest
│   ├── base.nix           # stateVersion, EDITOR
│   ├── zsh.nix            # zsh + p10k + plugins + aliases
│   ├── tmux.nix           # tmux + Catppuccin + resurrect
│   ├── nvim.nix           # neovim + LSPs + formatters
│   └── development.nix    # direnv + fd/bat/jq
└── dotfiles/
    └── nvim/              # LazyVim Lua config
```

## Notes

- **Git**: not managed by Nix here. Use Ubuntu's `apt install git` or add your own module.
- **tmux-sessionizer**: the `prefix + C-f` keybinding expects `~/.local/bin/tmux-sessionizer`. If it's not installed, the keybinding is a no-op — or install a script like [ThePrimeagen's tmux-sessionizer](https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer).
- **LazyVim**: the first few neovim launches take longer while plugins install. `:Lazy` shows progress.
