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

    # WICHTIG: Keine plugins hier, LazyVim managed die!
    extraPackages = with pkgs; [
      # LSP Servers (minimal)
      lua-language-server
      nil
      marksman

      # Formatters
      stylua
      nixpkgs-fmt

      # Essential Tools
      ripgrep
      fd
      lazygit
    ];
  };

  # LazyVim Config symlinken
  home.file.".config/nvim" = {
    source = ../dotfiles/nvim;
    recursive = true;
  };
}
