{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    font = {
      name = "Maple Mono NF";
      size = 12;
    };
    
    settings = {
      # Window settings
      remember_window_size = false;
      initial_window_width = 1200;
      initial_window_height = 1000;
      window_padding_width = 10;
      window_margin_width = 10;
      window_border_width = "1pt";
      single_window_margin_width = 0;
      hide_window_decorations = false;
      
      # Cursor
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = 1;
      
      # Scrollback
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      
      # Audio
      enable_audio_bell = false;
      
      # Opacity and blur
      dynamic_background_opacity = true;
      background_opacity = "0.92";
      background_blur = 99;
      background_tint = "0.0";
      
      # Wayland
      linux_display_server = "wayland";
      
      # Misc
      confirm_os_window_close = 0;
      allow_remote_control = true;
      copy_on_select = true;
      
      # Borders
      active_border_color = "#00E5FF";
      inactive_border_color = "#3D2066";
      
      # Layouts
      enabled_layouts = "Tall, *";
      
      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    
    keybindings = {
      # New window with current directory
      "f1" = "new_window_with_cwd";
      "f2" = "launch --cwd=current nvim .";
      
      # Navigation
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      
      # Disable split shortcuts (using niri/MangoWC for window management)
      "ctrl+shift+enter" = "no_op";
      "ctrl+shift+n" = "no_op";
      "ctrl+shift+w" = "no_op";
      "ctrl+shift+f" = "no_op";
      "ctrl+shift+r" = "no_op";
      "ctrl+shift+l" = "no_op";
      "ctrl+shift+q" = "no_op";
    };
    
    # Theme will be added via extraConfig to include the custom theme
    extraConfig = ''
      # Electrify Purple Theme
      foreground            #E0E0E0
      background            #1A0033
      selection_foreground  #1A0033
      selection_background  #00E5FF
      
      cursor                #00E5FF
      cursor_text_color     #1A0033
      
      # Black
      color0   #1A0033
      color8   #3D2066
      
      # Red
      color1   #FF0080
      color9   #FF66B2
      
      # Green
      color2   #00FF9F
      color10  #66FFB2
      
      # Yellow
      color3   #FFFF00
      color11  #FFFF66
      
      # Blue
      color4   #00E5FF
      color12  #66F0FF
      
      # Magenta
      color5   #FF00FF
      color13  #FF66FF
      
      # Cyan
      color6   #00FFFF
      color14  #66FFFF
      
      # White
      color7   #E0E0E0
      color15  #FFFFFF
      
      # Cursor trail effect
      cursor_trail 1
      cursor_trail_decay 0.1 0.4
    '';
  };
}
