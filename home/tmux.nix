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
      # catppuccin is loaded manually below (load order matters)
    ];

    extraConfig = ''
      # Bell passthrough for Claude Code notifications
      set -g allow-passthrough on
      set -g monitor-bell on
      set -g bell-action any

      # Number windows and panes from 1
      set -g base-index 1
      setw -g pane-base-index 1

      # Disable automatic window renaming; use current path instead
      set -g automatic-rename off
      set-hook -g after-new-window 'rename-window "#{b:pane_current_path}"'
      set-hook -g after-new-session 'rename-window "#{b:pane_current_path}"'

      # Prefix: Ctrl+Space (in addition to Ctrl+b)
      set -g prefix2 C-Space
      bind C-Space send-prefix -2

      # Open new windows and splits in the current path
      bind c new-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # Sessionizer: prefix + C-f (optional, script must be installed separately)
      bind C-f display-popup -w 60% -h 60% -E "$HOME/.local/bin/tmux-sessionizer"

      # --- tmux-resurrect ---
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'

      # --- Catppuccin v2 config ---
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_status_background "default"
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_text " #W"
      set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"

      # Load plugin
      run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

      # Assemble status modules AFTER the plugin is loaded
      set -g status-left-length 50
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_user}"
      set -ag status-right "#{E:@catppuccin_status_host}"

      # Transparent status bar
      set -g status-bg default
      set -g status-style "bg=default"

      # Status bar at the top
      set-option -g status-position top

      # Active pane border color
      set -g pane-active-border-style "fg=#fab387"
    '';
  };
}
