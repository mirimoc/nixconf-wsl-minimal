{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withRuby = false;
    withPython3 = false;

    # IMPORTANT: no plugins here, LazyVim manages them!
    extraPackages = with pkgs; [
      # LSP servers (minimal set)
      lua-language-server
      nil
      marksman

      # Formatters
      stylua
      nixpkgs-fmt

      # Essential tools
      ripgrep
      fd
      lazygit
    ];
  };

  # Symlink LazyVim config
  home.file.".config/nvim" = {
    source = ../dotfiles/nvim;
    recursive = true;
  };
}
