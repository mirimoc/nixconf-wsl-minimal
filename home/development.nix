{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    bat
    jq
    lazygit
  ];

  # direnv: auto-activate dev shells on cd
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
