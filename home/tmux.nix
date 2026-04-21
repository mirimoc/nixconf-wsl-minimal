{ pkgs, ...} :

{
programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      cpu
      resurrect
      # catppuccin wird manuell in extraConfig geladen (Reihenfolge!)
    ];

    extraConfig = ''
      # Bell-Passthrough für Claude Code Benachrichtigungen
      set -g allow-passthrough on
      set -g monitor-bell on
      set -g bell-action any

      # Windows und Panes ab 1 nummerieren
      set -g base-index 1
      setw -g pane-base-index 1

      # Automatische Umbenennung deaktivieren
      set -g automatic-rename off
      set-hook -g after-new-window 'rename-window "#{b:pane_current_path}"'
      set-hook -g after-new-session 'rename-window "#{b:pane_current_path}"'

      # Prefix: Ctrl+Space (zusätzlich zu Ctrl+b)
      set -g prefix2 C-Space
      bind C-Space send-prefix -2

      # Keybindings: Neue Fenster und Splits im aktuellen Pfad öffnen
      bind c new-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # Sessionizer: Prefix + Ctrl-f (optional, Skript muss separat installiert sein)
      bind C-f display-popup -w 60% -h 60% -E "$HOME/.local/bin/tmux-sessionizer"

      # --- tmux-resurrect ---
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'

      # --- Catppuccin v2 Konfiguration ---
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_status_background "default"
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_text " #W"
      set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"

      # Plugin laden
      run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

      # Status-Module NACH dem Plugin-Load zusammenbauen
      set -g status-left-length 50
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_user}"
      set -ag status-right "#{E:@catppuccin_status_host}"

      # Status bar transparent
      set -g status-bg default
      set -g status-style "bg=default"

      # Status bar position at the top
      set-option -g status-position top

      # Active pane border color
      set -g pane-active-border-style "fg=#fab387"
    '';
  };
}
