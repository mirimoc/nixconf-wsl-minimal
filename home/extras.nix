{ pkgs, ... }:

# Catch-all for ad-hoc packages — anything that doesn't belong in a
# topic-specific module (python.nix, development.nix, nvim.nix, ...).
# Add here when you quickly need something; promote to its own module
# once it grows into a coherent feature set.
# Search nixpkgs: https://search.nixos.org/packages
#
# Apply with: home-manager switch --flake .#home   (alias: sw)

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts (Nerd Fonts). See docs/fonts.md for Windows Terminal setup.
    nerd-fonts.monofur

    # Node / JS
    # nodejs_22
    # bun
    # pnpm

    # Rust
    # rustup

    # Databases / clients
    # postgresql
    # sqlite
    # redis

    # Cloud / infra
    # awscli2
    # kubectl
    # terraform

    # Misc
    # httpie
    # yq
    # gh
  ];
}
