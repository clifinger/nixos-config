# MangoWC Window Manager configuration
{ inputs, outputs, lib, config, pkgs, ... }:

{
  wayland.windowManager.mango = {
    enable = true;
    
    settings = ''
      # ===== Window Effects =====
      blur=1
      blur_optimized=1
      blur_params_radius=5
      shadows=1
      shadow_only_floating=1
      border_radius=8
      focused_opacity=1.0
      unfocused_opacity=0.95
      
      # ===== Animations =====
      animations=1
      animation_type_open=slide
      animation_type_close=slide
      animation_duration_open=300
      animation_duration_close=400
      
      # ===== Appearance =====
      gappih=8
      gappiv=8
      gappoh=12
      gappov=12
      borderpx=2
      bordercolor=0x444444ff
      focuscolor=0x89b4faff
      
      # ===== Keyboard =====
      repeat_rate=25
      repeat_delay=600
      xkb_rules_layout=us
      
      # ===== Scroller Layout =====
      scroller_default_proportion=0.8
      scroller_focus_center=0
      scroller_prefer_center=0
      scroller_proportion_preset=0.5,0.8,1.0
      
      # ===== Multi-Monitor =====
      focus_cross_monitor=1
      warpcursor=1
      sloppyfocus=1
      
      # ===== Monitor Configuration =====
      # eDP-1 (built-in): 2560x1600 @ 1.3 scale, position: 0,0
      monitorrule=eDP-1,0.55,1,scroller,0,1.3,0,0,2560,1600,60
      
      # DP-4 (HP Z27n): 2560x1440 @ 1.0 scale, position: 1969,0
      monitorrule=DP-4,0.55,1,scroller,0,1.0,1969,0,2560,1440,60
      
      # DP-6 (Xiaomi 4K): 3840x2160 @ 1.5 scale, position: 4529,0
      monitorrule=DP-6,0.55,1,scroller,0,1.5,4529,0,3840,2160,60
      
      # ===== Window Rules =====
      windowrule=isnamedscratchpad:1,scratchpad_width:1500,scratchpad_height:900,appid:scratchpad-term
      windowrule=tags:9,isopensilent:1,istagsilent:1,title:Franz
      
      # ===== Workspace Layout =====
      tagrule=id:1,layout_name:scroller
      tagrule=id:2,layout_name:scroller
      tagrule=id:3,layout_name:scroller
      tagrule=id:4,layout_name:scroller
      tagrule=id:5,layout_name:scroller
      tagrule=id:6,layout_name:scroller
      tagrule=id:7,layout_name:scroller
      tagrule=id:8,layout_name:scroller
      tagrule=id:9,layout_name:scroller
      
      # ===== KEYBINDINGS =====
      
      # System
      bind=SUPER,r,spawn_shell,mmsg -d reload_config && sleep 0.2 && mmsg -d setlayout,scroller
      bind=SUPER+SHIFT,r,spawn,dms restart
      
      # Applications
      bind=SUPER,Return,spawn,kitty
      bind=SUPER,b,spawn,chromium
      bind=SUPER,e,spawn,nautilus
      
      # DankMaterialShell widgets
      bind=SUPER,d,spawn,dms ipc call dash toggle overview
      bind=ALT,space,spawn,dms ipc call spotlight toggle
      bind=SUPER,v,spawn,dms ipc call clipboard toggle
      bind=SUPER+SHIFT,n,spawn,dms ipc call notifications toggle
      bind=SUPER,BackSpace,spawn,dms ipc call powermenu toggle
      bind=SUPER,l,spawn,dms ipc call lock lock
      
      # Window management
      bind=SUPER,q,killclient,
      bind=SUPER,f,togglefloating,
      bind=SUPER,m,setlayout,monocle
      bind=SUPER+SHIFT,m,togglefullscreen,
      bind=SUPER,a,toggleoverview,
      
      # Window navigation
      bind=SUPER,Tab,focusstack,next
      bind=SUPER,Left,focusdir,left
      bind=SUPER,Right,focusdir,right
      bind=SUPER,Up,focusdir,up
      bind=SUPER,Down,focusdir,down
      
      # Move windows
      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down
      
      # Resize floating windows
      bind=CTRL+SUPER,Left,smartresizewin,left
      bind=CTRL+SUPER,Right,smartresizewin,right
      bind=CTRL+SUPER,Up,smartresizewin,up
      bind=CTRL+SUPER,Down,smartresizewin,down
      bind=SUPER,equal,resizewin,80,80
      bind=SUPER,minus,resizewin,-80,-80
      
      # Move floating windows
      bind=ALT+SUPER,Left,smartmovewin,left
      bind=ALT+SUPER,Right,smartmovewin,right
      bind=ALT+SUPER,Up,smartmovewin,up
      bind=ALT+SUPER,Down,smartmovewin,down
      
      # Layouts
      bind=SUPER,s,setlayout,scroller
      bind=SUPER,n,spawn,/home/julien/.config/mango/toggle-layout.sh
      bind=SUPER,0,switch_proportion_preset
      
      # Screenshots
      bind=CTRL,Print,spawn_shell,filename="screenshot-$(date +%Y%m%d-%H%M%S).png" && grim /home/julien/Pictures/$filename && notify-send "Screenshot" "Saved: $filename"
      bind=SUPER,Print,spawn_shell,filename="screenshot-$(date +%Y%m%d-%H%M%S).png" && grim -g "$(slurp)" /home/julien/Pictures/$filename && notify-send "Screenshot" "Area saved: $filename"
      bind=SUPER+SHIFT,Print,spawn_shell,grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Area copied to clipboard"
      
      # Media keys
      bind=none,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind=none,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind=none,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=none,XF86AudioMicMute,spawn_shell,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo 1 || echo 0) | sudo tee /sys/class/leds/platform::micmute/brightness > /dev/null
      bind=none,XF86MonBrightnessUp,spawn,brightnessctl set 5%+
      bind=none,XF86MonBrightnessDown,spawn,brightnessctl set 5%-
      
      # Scratchpad
      bind=ALT,z,toggle_named_scratchpad,scratchpad-term,none,kitty --class scratchpad-term
      
      # Monitor navigation (PgUp/PgDn)
      bind=SUPER,code:112,focusmon,left
      bind=SUPER,code:117,focusmon,right
      bind=SUPER+SHIFT,code:112,tagmon,left,0
      bind=SUPER+SHIFT,code:117,tagmon,right,0
      
      # Touchpad gestures
      gesturebind=none,left,3,focusstack,prev
      gesturebind=none,right,3,focusstack,next
      
      # Workspaces
      bind=SUPER,0,view,0,0
      bind=SUPER,1,view,1,0
      bind=SUPER,2,view,2,0
      bind=SUPER,3,view,3,0
      bind=SUPER,4,view,4,0
      bind=SUPER,5,view,5,0
      bind=SUPER,6,view,6,0
      bind=SUPER,7,view,7,0
      bind=SUPER,8,view,8,0
      bind=SUPER,9,view,9,0
      
      # Move to workspace
      bind=SUPER+SHIFT,0,tag,0,0
      bind=SUPER+SHIFT,1,tag,1,0
      bind=SUPER+SHIFT,2,tag,2,0
      bind=SUPER+SHIFT,3,tag,3,0
      bind=SUPER+SHIFT,4,tag,4,0
      bind=SUPER+SHIFT,5,tag,5,0
      bind=SUPER+SHIFT,6,tag,6,0
      bind=SUPER+SHIFT,7,tag,7,0
      bind=SUPER+SHIFT,8,tag,8,0
      bind=SUPER+SHIFT,9,tag,9,0
      
      # Mouse bindings
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_right,moveresize,curresize
    '';
    
    autostart_sh = ''
      # Wait for PipeWire to be ready
      for i in {1..30}; do
        wpctl status &>/dev/null && break
        sleep 0.2
      done
      
      # XDG Desktop Portal
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots &
      
      # Clipboard utilities
      wl-clip-persist --clipboard regular --reconnect-tries 0 &
      wl-paste --type text --watch cliphist store &
      
      # Start DankMaterialShell
      dms run &
      
      # Start Franz hidden (for notifications)
      sleep 2 && franz &
    '';
  };
  
  # Toggle layout script
  home.file.".config/mango/toggle-layout.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Toggle between tile and scroller layouts
      
      current=$(mmsg -g | grep "layout" | grep -v "kb_layout" | head -1 | awk '{print $3}')
      
      if [ "$current" = "S" ]; then
          mmsg -d setlayout,tile
      else
          mmsg -d setlayout,scroller
      fi
    '';
    executable = true;
  };
}
