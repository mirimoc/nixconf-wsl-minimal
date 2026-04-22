{ username, ... }:

{
  imports = [
    ./base.nix
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
    ./development.nix
    ./python.nix
    ./extras.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
}
