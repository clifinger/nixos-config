{
  description = "NixOS avec MangoWC et DankMaterialShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, mangowc, dms, ... }:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
            
            # Activer MangoWC
            mangowc.nixosModules.mango
            
            home-manager.nixosModules.home-manager
            {
              # Enable MangoWC au niveau système
              programs.mango.enable = true;
              
              # Configuration Home Manager
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                
                users.julien = { pkgs, ... }: {
                  imports = [ 
                    mangowc.hmModules.mango
                    dms.homeModules.dankMaterialShell.default
                    ./home-manager/home.nix
                  ];
                  
                  # Configuration MangoWC avec raccourcis
                  wayland.windowManager.mango = {
                    enable = true;
                    settings = ''
                      # Configuration MangoWC
                      
                      # Effets visuels
                      blur=1
                      blur_optimized=1
                      blur_params_radius=5
                      shadows=1
                      shadow_only_floating=1
                      border_radius=8
                      focused_opacity=1.0
                      unfocused_opacity=0.95
                      
                      # Animations
                      animations=1
                      animation_type_open=slide
                      animation_type_close=slide
                      animation_duration_open=300
                      animation_duration_close=400
                      
                      # Apparence
                      gappih=8
                      gappiv=8
                      gappoh=12
                      gappov=12
                      borderpx=2
                      bordercolor=0x444444ff
                      focuscolor=0x89b4faff
                      
                      # Clavier
                      repeat_rate=25
                      repeat_delay=600
                      xkb_rules_layout=us
                      
                      # Curseur (taille de base, sera automatiquement scalé à 36 par le monitorrule)
                      cursor_size=24
                      cursor_theme=Adwaita
                      env=XCURSOR_SIZE,24
                      env=XCURSOR_THEME,Adwaita
                      env=GDK_SCALE,1.3
                      env=QT_SCALE_FACTOR,1.3
                      
                      # Échelle de l'écran (1.3x)
                      monitorrule=eDP-1,0.55,1,tile,0,1.3,0,0,2560,1600,60
                      
                      # Window rules pour scratchpad
                      windowrule=isnamedscratchpad:1,scratchpad_width:1500,scratchpad_height:900,appid:scratchpad-term
                      
                      # ========== RACCOURCIS CLAVIER ==========
                      
                      # Reload MangoWC config
                      bind=SUPER,r,reload_config
                      
                      # Restart DankMaterialShell
                      bind=SUPER+SHIFT,r,spawn,dms restart
                      
                      # KITTY TERMINAL - Super+Enter
                      bind=SUPER,Return,spawn,kitty
                      
                      # CHROMIUM - Super+b (b pour browser)
                      bind=SUPER,b,spawn,chromium
                      
                      # NAUTILUS - Super+e (e pour explorer)
                      bind=SUPER,e,spawn,nautilus
                      
                      # Dashboard DMS - Super+d (overview tab)
                      bind=SUPER,d,spawn,dms ipc call dash toggle overview
                      
                      # Launcher DMS - Alt+space
                      bind=ALT,space,spawn,dms ipc call spotlight toggle
                      
                      # Settings DMS - Super+s
                      bind=SUPER,s,spawn,dms ipc call settings toggle
                      
                      # Control Center DMS - Super+Shift+c
                      bind=SUPER+SHIFT,c,spawn,dms ipc call controlcenter toggle
                      
                      # Fermer une fenêtre (killclient)
                      bind=SUPER,q,killclient,
                      bind=SUPER,w,killclient,
                      
                      # Quitter MangoWC (SUPER+SHIFT+q)
                      bind=SUPER+SHIFT,q,quit
                      
                      # Navigation entre fenêtres
                      bind=SUPER,Tab,focusstack,next
                      bind=SUPER,h,focusdir,left
                      bind=SUPER,l,focusdir,right
                      bind=SUPER,k,focusdir,up
                      bind=SUPER,j,focusdir,down
                      bind=SUPER,Left,focusdir,left
                      bind=SUPER,Right,focusdir,right
                      bind=SUPER,Up,focusdir,up
                      bind=SUPER,Down,focusdir,down
                      
                      # Déplacer les fenêtres
                      bind=SUPER+SHIFT,h,exchange_client,left
                      bind=SUPER+SHIFT,l,exchange_client,right
                      bind=SUPER+SHIFT,k,exchange_client,up
                      bind=SUPER+SHIFT,j,exchange_client,down
                      bind=SUPER+SHIFT,Left,exchange_client,left
                      bind=SUPER+SHIFT,Right,exchange_client,right
                      bind=SUPER+SHIFT,Up,exchange_client,up
                      bind=SUPER+SHIFT,Down,exchange_client,down
                      
                      # Layouts - Super+N cycle tous les modes
                      bind=SUPER,n,switch_layout
                      
                      # Screenshots
                      bind=CTRL,Print,spawn_shell,filename="screenshot-$(date +%Y%m%d-%H%M%S).png" && grim /home/julien/Pictures/$filename && notify-send "Screenshot" "Saved: $filename"
                      bind=SUPER,Print,spawn_shell,filename="screenshot-$(date +%Y%m%d-%H%M%S).png" && grim -g "$(slurp)" /home/julien/Pictures/$filename && notify-send "Screenshot" "Area saved: $filename"
                      bind=SUPER+SHIFT,Print,spawn_shell,grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Area copied to clipboard"
                      
                      # Touches multimédia (volume et luminosité) - Fn+F1, Fn+F2, etc.
                      bind=none,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
                      bind=none,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
                      bind=none,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
                      bind=none,XF86AudioMicMute,spawn_shell,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo 1 || echo 0) | sudo tee /sys/class/leds/platform::micmute/brightness > /dev/null
                      bind=none,XF86MonBrightnessUp,spawn,brightnessctl set 5%+
                      bind=none,XF86MonBrightnessDown,spawn,brightnessctl set 5%-
                      
                      # États des fenêtres
                      bind=SUPER,f,togglefullscreen,
                      bind=SUPER,space,togglefloating,
                      bind=SUPER,m,togglemaximizescreen,
                      bind=SUPER,o,toggleoverview,
                      
                      # Scratchpad - Alt+z pour terminal scratchpad
                      bind=ALT,z,toggle_named_scratchpad,scratchpad-term,scratchpad-term,kitty --class scratchpad-term
                      
                      # Workspaces (tags)
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
                      
                      # Déplacer vers workspace
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
                      
                      # Souris
                      mousebind=SUPER,btn_left,moveresize,curmove
                      mousebind=SUPER,btn_right,moveresize,curresize
                      
                      # Layouts par défaut - Scroller pour tous les workspaces
                      tagrule=id:1,layout_name:scroller
                      tagrule=id:2,layout_name:scroller
                      tagrule=id:3,layout_name:scroller
                      tagrule=id:4,layout_name:scroller
                      tagrule=id:5,layout_name:scroller
                      tagrule=id:6,layout_name:scroller
                      tagrule=id:7,layout_name:scroller
                      tagrule=id:8,layout_name:scroller
                      tagrule=id:9,layout_name:scroller
                    '';
                    
                    autostart_sh = ''
                      # Attendre que PipeWire soit prêt
                      for i in {1..30}; do
                        wpctl status &>/dev/null && break
                        sleep 0.2
                      done
                      
                      # Démarrer DankMaterialShell
                      dms run &
                    '';
                  };
                  
                  # Activer DankMaterialShell
                  programs.dankMaterialShell = {
                    enable = true;
                    systemd.enable = true;
                  };
                };
              };
            }
          ];
        };
      };
    };
}
