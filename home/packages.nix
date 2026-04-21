{ pkgs, ... }:

# Project- / machine-specific packages.
# Add anything that isn't part of the minimal baseline here.
# Search nixpkgs: https://search.nixos.org/packages
#
# Apply with: home-manager switch --flake .#wsl   (alias: sw)

{
  home.packages = with pkgs; [
    # Python
    # python3
    # poetry
    # uv

    # Node / JS
    # nodejs_22
    # bun
    # pnpm

    # Go
    # go
    # gopls

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
