{ pkgs, lib, ... }:

{
  programs.tmux = {
    baseIndex = 1;
    escapeTime = 0;
    enable = true;
    extraConfig = ''
      set-option -sa terminal-features ',xterm-kitty:RGB'
      set-environment -g COLORTERM "truecolor"
      set-option -g focus-events on
      set-window-option -g xterm-keys on

      # Smart pane switching with awareness of vim splits
      is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|(n)?vim?)(diff)?$"'
      bind -n M-n if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n M-e if-shell "$is_vim" "send-keys C-j" "select-pane -D"
      bind -n M-i if-shell "$is_vim" "send-keys C-k" "select-pane -U"
      bind -n M-o if-shell "$is_vim" "send-keys C-l" "select-pane -R"

      # act like vim
      bind n select-pane -L
      bind e select-pane -D
      bind i select-pane -U
      bind o select-pane -R
      bind-key -r C-l select-window -t :-
      bind-key -r C-u select-window -t :+

      bind Up resize-pane -U 15
      bind Down resize-pane -D 15
      bind Left resize-pane -L 25
      bind Right resize-pane -R 25

      set -g @catppuccin-flavour 'macchiato'
    '';
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-x";
    plugins = with pkgs; [{
      plugin = tmuxPlugins.catppuccin;
      extraConfig = ''
        set -g @catppuccin_flavour 'frappe'

        set -g @catppuccin_window_left_separator ""
        set -g @catppuccin_window_right_separator " "
        set -g @catppuccin_window_middle_separator " █"
        set -g @catppuccin_window_number_position "right"

        set -g @catppuccin_window_default_fill "number"
        set -g @catppuccin_window_default_text "#W"

        set -g @catppuccin_window_current_fill "number"
        set -g @catppuccin_window_current_text "#W"

        set -g @catppuccin_status_modules_right "session date_time"
        set -g @catppuccin_status_left_separator  " "
        set -g @catppuccin_status_right_separator ""
        set -g @catppuccin_status_right_separator_inverse "no"
        set -g @catppuccin_status_fill "icon"
        set -g @catppuccin_status_connect_separator "no"

        set -g @catppuccin_date_time_text "%a %-d %b %H:%M"
      '';
    }];
    terminal = "screen-256color";
  };
}
