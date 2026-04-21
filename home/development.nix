{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    bat
    jq
  ];

  # Direnv: Automatisches Aktivieren von Dev-Shells beim cd
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
