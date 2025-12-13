{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    font = {
      name = "Maple Mono NF";
      size = 13;
    };
    
    settings = {
      remember_window_size = false;
      initial_window_width = 1200;
      initial_window_height = 1000;
      
      window_padding_width = 10;
      window_margin_width = 10;
      single_window_margin_width = 0;
      
      window_border_width = "1pt";
      hide_window_decorations = false;
      active_border_color = "#00E5FF";
      inactive_border_color = "#3D2066";
      
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = 1;
      
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      
      enable_audio_bell = false;
      
      dynamic_background_opacity = true;
      background_opacity = "0.92";
      background_blur = 99;
      background_tint = "0.0";
      
      linux_display_server = "wayland";
      
      allow_remote_control = true;
      
      confirm_os_window_close = 0;
      copy_on_select = true;
      
      kitty_mod = "ctrl+shift";
      
      enabled_layouts = "Tall, *";
      
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    
    keybindings = {      
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      
      "ctrl+shift+enter" = "no_op";
      "ctrl+shift+n" = "no_op";
      "ctrl+shift+w" = "no_op";
      "ctrl+shift+f" = "no_op";
      "ctrl+shift+r" = "no_op";
      "ctrl+shift+l" = "no_op";
      "ctrl+shift+q" = "no_op";
      
      "f1" = "no_op";
      "f2" = "no_op";
      "f3" = "no_op";
    };
    
    extraConfig = ''
      include dank-theme.conf
      
      cursor #00E5FF
      cursor_text_color #000000
      
      cursor_trail 1
      cursor_trail_decay 0.1 0.4
      
      map ctrl+shift+u no_op
    '';
  };
}
