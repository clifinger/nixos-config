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
                      
                      # ========== RACCOURCIS CLAVIER ==========
                      
                      # Reload config
                      bind=SUPER,r,reload_config
                      
                      # KITTY TERMINAL - Super+Return (raccourci principal)
                      bind=SUPER,Return,spawn,kitty
                      
                      # CHROMIUM - Super+b (b pour browser)
                      bind=SUPER,b,spawn,chromium
                      
                      # Launcher DMS
                      bind=SUPER,d,spawn,dms ipc call spotlight toggle
                      
                      # Quitter et fermer
                      bind=SUPER,q,quit
                      bind=SUPER,c,killclient,
                      
                      # Navigation entre fenêtres
                      bind=SUPER,Tab,focusstack,next
                      bind=SUPER,h,focusdir,left
                      bind=SUPER,l,focusdir,right
                      bind=SUPER,k,focusdir,up
                      bind=SUPER,j,focusdir,down
                      
                      # Déplacer les fenêtres
                      bind=SUPER+SHIFT,h,exchange_client,left
                      bind=SUPER+SHIFT,l,exchange_client,right
                      bind=SUPER+SHIFT,k,exchange_client,up
                      bind=SUPER+SHIFT,j,exchange_client,down
                      
                      # États des fenêtres
                      bind=SUPER,f,togglefullscreen,
                      bind=SUPER,space,togglefloating,
                      bind=SUPER,m,togglemaximizescreen,
                      bind=SUPER,o,toggleoverview,
                      
                      # Workspaces (tags)
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
                      bind=SUPER+SHIFT,1,tag,1,0
                      bind=SUPER+SHIFT,2,tag,2,0
                      bind=SUPER+SHIFT,3,tag,3,0
                      bind=SUPER+SHIFT,4,tag,4,0
                      bind=SUPER+SHIFT,5,tag,5,0
                      bind=SUPER+SHIFT,6,tag,6,0
                      bind=SUPER+SHIFT,7,tag,7,0
                      bind=SUPER+SHIFT,8,tag,8,0
                      bind=SUPER+SHIFT,9,tag,9,0
                      
                      # Navigation workspaces
                      bind=SUPER,Left,viewtoleft,0
                      bind=SUPER,Right,viewtoright,0
                      
                      # Souris
                      mousebind=SUPER,btn_left,moveresize,curmove
                      mousebind=SUPER,btn_right,moveresize,curresize
                      
                      # Layouts
                      tagrule=id:1,layout_name:tile
                      tagrule=id:2,layout_name:tile
                      tagrule=id:3,layout_name:tile
                      tagrule=id:4,layout_name:tile
                      tagrule=id:5,layout_name:tile
                      tagrule=id:6,layout_name:tile
                      tagrule=id:7,layout_name:tile
                      tagrule=id:8,layout_name:tile
                      tagrule=id:9,layout_name:tile
                    '';
                    
                    autostart_sh = ''
                      # Démarrer DankMaterialShell
                      dms run &
                    '';
                  };
                  
                  # Activer DankMaterialShell
                  programs.dankMaterialShell = {
                    enable = true;
                    systemd.enable = true;
                  };
                  
                  home.stateVersion = "25.11";
                };
              };
            }
          ];
        };
      };
    };
}
