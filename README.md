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
- Flakes enabled. The Determinate installer enables them by default. With the official installer you need to opt in:
  ```bash
  mkdir -p ~/.config/nix
  echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
  ```
  If you see `error: experimental Nix feature 'nix-command' is disabled`, this step was skipped.

## Installation

### Scripted (recommended)

```bash
git clone https://github.com/mirimoc/nixconf-wsl-minimal ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` handles: enabling flakes, starting `nix-daemon` on WSL without systemd,
patching the `username` in `flake.nix` to match `$USER`, running the activation,
and offering `chsh -s $(which zsh)`.

### Manual

```bash
git clone https://github.com/mirimoc/nixconf-wsl-minimal ~/dotfiles
cd ~/dotfiles

# If your WSL username is not 'mirimoc':
# open flake.nix and adjust `username = "mirimoc"`

# Activate (uses the exact home-manager version pinned in flake.lock)
nix run .#homeConfigurations.wsl.activationPackage

# Subsequent switches (home-manager is now on PATH)
# home-manager switch --flake .#wsl

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

If you haven't activated yet (no `home-manager` on PATH), use the first-time command instead:
```bash
nix run .#homeConfigurations.wsl.activationPackage
```

## Troubleshooting

### `error opening lock file ... Permission denied`

Multi-user Nix was installed, but the `nix-daemon` isn't running. WSL doesn't run
systemd by default, so the daemon never starts automatically.

**Quick fix (per session):**
```bash
sudo /nix/var/nix/profiles/default/bin/nix-daemon --daemon &
disown
```

Use the absolute path — `sudo`'s `secure_path` doesn't include the Nix profile bin.

**Persistent fix (requires WSL admin):** enable systemd in WSL.

In WSL:
```bash
sudo tee -a /etc/wsl.conf > /dev/null <<'EOF'

[boot]
systemd=true
EOF
```

Then in **Windows PowerShell** (not WSL):
```
wsl --shutdown
```

Re-open WSL — the daemon now starts automatically.

**No admin rights on Windows?** Auto-start the daemon per login by adding to `~/.zshenv` or `~/.bashrc`:
```bash
pgrep -x nix-daemon >/dev/null || sudo -n /nix/var/nix/profiles/default/bin/nix-daemon --daemon &>/dev/null &
```
(requires passwordless sudo for `nix-daemon`).

### `error: experimental Nix feature 'nix-command' is disabled`

See the [Prerequisites](#prerequisites) section — flakes need to be opted in with the official installer.

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
