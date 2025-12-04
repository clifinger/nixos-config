{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    # Font configuration - Maple Mono Nerd Font
    font = {
      name = "Maple Mono NF";
      size = 13;
    };
    
    settings = {
      # Window geometry
      remember_window_size = false;
      initial_window_width = 1200;
      initial_window_height = 1000;
      
      # Padding and margins
      window_padding_width = 10;
      window_margin_width = 10;
      single_window_margin_width = 0;
      
      # Window decorations
      window_border_width = "1pt";
      hide_window_decorations = false;
      active_border_color = "#00E5FF";
      inactive_border_color = "#3D2066";
      
      # Cursor configuration
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = 1;
      
      # Scrollback
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      
      # Audio
      enable_audio_bell = false;
      
      # Background effects
      dynamic_background_opacity = true;
      background_opacity = "0.92";
      background_blur = 99;
      background_tint = "0.0";
      
      # Platform specific
      linux_display_server = "wayland";
      
      # Remote control for dynamic padding (nvim integration)
      allow_remote_control = true;
      
      # Misc
      confirm_os_window_close = 0;
      copy_on_select = true;
      
      # Disable enhanced keyboard protocol (causes issues with ThinkPad Fn keys)
      kitty_mod = "ctrl+shift";
      
      # Layouts (using niri for tiling)
      enabled_layouts = "Tall, *";
      
      # Tab bar styling
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    
    # Keybindings optimized for tiling WM usage
    keybindings = {      
      # Window navigation (minimal - let niri handle most)
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      
      # Disable conflicting shortcuts (niri handles window management)
      "ctrl+shift+enter" = "no_op";
      "ctrl+shift+n" = "no_op";
      "ctrl+shift+w" = "no_op";
      "ctrl+shift+f" = "no_op";
      "ctrl+shift+r" = "no_op";
      "ctrl+shift+l" = "no_op";
      "ctrl+shift+q" = "no_op";
      
      # Allow function keys to pass through (for ThinkPad Fn keys)
      "f1" = "no_op";
      "f2" = "no_op";
      "f3" = "no_op";
    };
    
    # Theme: Dynamic from DMS
    extraConfig = ''
      # Include dynamic theme from DMS
      include dank-theme.conf
      
      # Override cursor color for better contrast in nvim normal mode
      cursor #00E5FF
      cursor_text_color #000000
      
      # ===== Cursor Trail Effect =====
      cursor_trail 1
      cursor_trail_decay 0.1 0.4
      
      # Use legacy keyboard mode (disable CSI u mode that breaks Fn keys)
      map ctrl+shift+u no_op
    '';
  };
}
