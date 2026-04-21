{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    zsh-autocomplete
    zsh-fast-syntax-highlighting
    zsh-completions
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Runs in .zshenv — also applies to non-interactive shells
    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
        file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      }
    ];

    shellAliases = {
      c = "clear";
      e = "exit";
      v = "nvim";
      lg = "lazygit";
      sv = "sudo -E nvim";
      ll = "ls -la";
      nf = "cd ~/dotfiles";
      gb = "nix-collect-garbage -d";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    initContent = ''
      # Load p10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Enable instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Load powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
