#!/usr/bin/env bash
# Installer for nixconf-wsl-minimal.
# Handles flakes opt-in, nix-daemon startup, username patching, and activation.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAKE_PATH="$SCRIPT_DIR/flake.nix"
NIX_DAEMON_BIN="/nix/var/nix/profiles/default/bin/nix-daemon"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m==>\033[0m %s\n' "$*" >&2; }
die()   { printf '\033[1;31m==>\033[0m %s\n' "$*" >&2; exit 1; }

# 1. Sanity check
command -v nix >/dev/null || die "nix is not installed. See https://install.determinate.systems/"
[[ -f "$FLAKE_PATH" ]] || die "flake.nix not found next to install.sh — run from the repo root."

# 2. Enable flakes if needed
NIX_CONF="$HOME/.config/nix/nix.conf"
if ! nix --version >/dev/null 2>&1 || ! nix flake --help >/dev/null 2>&1; then
  info "Enabling experimental features (nix-command, flakes)"
  mkdir -p "$(dirname "$NIX_CONF")"
  if ! grep -q "experimental-features" "$NIX_CONF" 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> "$NIX_CONF"
  fi
fi

# 3. Start nix-daemon if multi-user install and daemon not running
if [[ -d /nix/store ]] && stat -c '%G' /nix/store 2>/dev/null | grep -q nixbld; then
  if ! pgrep -x nix-daemon >/dev/null 2>&1; then
    info "Starting nix-daemon (systemd-less WSL fallback)"
    if [[ -x "$NIX_DAEMON_BIN" ]]; then
      sudo "$NIX_DAEMON_BIN" --daemon >/dev/null 2>&1 &
      disown || true
      sleep 1
    else
      warn "nix-daemon binary not found at $NIX_DAEMON_BIN — continuing anyway"
    fi
  fi
fi

# 4. Patch username in flake.nix if it doesn't match $USER
CURRENT_USER="$(whoami)"
FLAKE_USER="$(grep -E '^\s*username\s*=' "$FLAKE_PATH" | head -1 | sed -E 's/.*"([^"]+)".*/\1/')"
if [[ "$FLAKE_USER" != "$CURRENT_USER" ]]; then
  info "Updating username in flake.nix: $FLAKE_USER -> $CURRENT_USER"
  sed -i.bak -E "s/(username\s*=\s*)\"[^\"]+\"/\1\"$CURRENT_USER\"/" "$FLAKE_PATH"
  rm -f "$FLAKE_PATH.bak"
fi

# 5. Activate
info "Running home-manager activation"
cd "$SCRIPT_DIR"
nix run .#homeConfigurations.wsl.activationPackage

# 6. Offer to switch default shell to zsh
if [[ "$(getent passwd "$CURRENT_USER" | cut -d: -f7)" != *zsh ]]; then
  ZSH_PATH="$(command -v zsh || true)"
  if [[ -n "$ZSH_PATH" ]]; then
    info "Set zsh as your default shell? (chsh -s $ZSH_PATH)  [y/N]"
    read -r reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      # Register zsh in /etc/shells if missing (chsh refuses otherwise)
      if ! grep -qx "$ZSH_PATH" /etc/shells 2>/dev/null; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null || true
      fi
      # Try unprivileged chsh first (needs the user's login password via PAM).
      # Fall back to `sudo chsh` if PAM auth fails or no login password is set.
      if ! chsh -s "$ZSH_PATH" 2>/dev/null; then
        warn "chsh failed (no login password?) — retrying with sudo"
        if ! sudo chsh -s "$ZSH_PATH" "$CURRENT_USER"; then
          warn "sudo chsh failed too — run manually or add 'exec zsh' to ~/.bashrc"
        fi
      fi
    fi
  fi
fi

info "Done. Open a new shell to pick up zsh + p10k."
