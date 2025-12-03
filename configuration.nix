# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Xanmod kernel.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Wayland support (MangoWC est un compositeur Wayland)
  # Pas besoin de X11 ni GNOME
  
  # TTY autologin pour démarrer MangoWC automatiquement
  services.getty.autologinUser = "julien";
  
  # Configuration du clavier (pour console)
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  
  # ThinkPad specific settings
  boot.kernelModules = [ "thinkpad_acpi" ];
  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1 hotkey=1
  '';
  
  # Fix ThinkPad hotkeys mask
  systemd.services.thinkpad-hotkeys = {
    description = "Enable all ThinkPad hotkeys";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 0xff8c7ffb > /sys/devices/platform/thinkpad_acpi/hotkey_mask'";
      RemainAfterExit = true;
    };
  };
  
  # Turn off micmute LED at boot
  systemd.services.micmute-led-off = {
    description = "Turn off micmute LED at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 0 > /sys/class/leds/platform::micmute/brightness'";
      RemainAfterExit = true;
    };
  };
  
  # fwupd pour mettre à jour les firmwares
  services.fwupd.enable = true;

  # ACPI n'est pas nécessaire sur les systèmes modernes (événements via input layer)
  # services.acpid.enable = true;
  
  # UPower pour la gestion de la batterie (requis pour DankMaterialShell)
  services.upower.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.julien = {
    isNormalUser = true;
    description = "Julien Lenne";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "seat" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    
    # Use zsh as default shell
    shell = pkgs.zsh;
  };
  
  # Enable zsh system-wide (CRITICAL: ensures shell always available)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   vim
   nano
   git
   wget
   curl
   github-cli
   github-copilot-cli
   chromium
   kitty
   foot
   
   # Wayland utilities
   wl-clipboard
   wl-clip-persist
   cliphist
   wlr-randr
   
   # Security tools
   bitwarden-cli
   jq
   gnupg
   openssh
   
   # System utilities
   evtest
   alsa-utils
   
   # Essential CLI tools (fallback when flake not applied)
   zsh
   eza
   bat
   fzf
   ripgrep
   fd
  ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Sudo sans mot de passe pour le groupe wheel
  security.sudo.wheelNeedsPassword = false;
  
  # Règle sudo pour le contrôle de la LED micmute
  security.sudo.extraRules = [{
    users = [ "julien" ];
    commands = [{
      command = "/run/current-system/sw/bin/tee /sys/class/leds/platform\\:\\:micmute/brightness";
      options = [ "NOPASSWD" ];
    }];
  }];
  
  # Polkit pour DankMaterialShell
  security.polkit.enable = true;
  
  # Enable dbus
  services.dbus.enable = true;
  
  # XDG Portal pour Wayland (pour screenshare, file picker, etc.)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };

  # Configuration pour démarrer MangoWC automatiquement
  # Note: Cette commande sera exécutée par le shell de login (zsh)
  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec mango
    fi
  '';

  # GPG Agent configuration avec support SSH
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  
  # DConf for GTK settings
  programs.dconf.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;  # Start manually with systemctl start docker
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
