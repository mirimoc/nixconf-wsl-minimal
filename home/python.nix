{ pkgs, ... }:

# Opt-in Python toolkit.
#
# Importing this module in home/home.nix turns the whole feature ON:
#   - installs Python runtime + tooling
#   - exposes basedpyright/ruff to Neovim
#   - writes a Lua flag file that LazyVim reads to load Python plugins
#
# Removing the import from home/home.nix turns it completely OFF:
#   no packages, no LSP binaries, no LazyVim Python plugins.
#
# Python packages per project go into a devShell / `uv` venv — not here.

{
  home.packages = with pkgs; [
    # Default on
    python3
    uv
    ruff
    basedpyright

    # Optional — uncomment as needed
    # poetry
    # pipx
    # debugpy
    # python3Packages.ipython
  ];

  # LSP binaries on Neovim's PATH (kept together with the feature so they
  # appear/disappear atomically when the module is toggled).
  programs.neovim.extraPackages = with pkgs; [
    basedpyright
    ruff
    # debugpy
  ];

  # Feature flag consumed by LazyVim. The plugin specs under
  # dotfiles/nvim/lua/plugins/ check vim.g.enable_python before registering.
  # If this module is not imported the file doesn't exist, the flag stays nil,
  # and the Python plugin spec returns {} (no plugins installed).
  home.file.".config/nvim/lua/config/features-python.lua".text = ''
    vim.g.enable_python = true
  '';
}
