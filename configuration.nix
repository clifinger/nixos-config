{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system/power-management.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Manila";

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

  services.getty.autologinUser = "julien";
  console.keyMap = "us";
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  boot.kernelModules = [ "thinkpad_acpi" "usbhid" ];
  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1 hotkey=1
  '';

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

  services.fwupd.enable = true;
  services.upower.enable = true;

  users.users.julien = {
    isNormalUser = true;
    description = "Julien Lenne";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "seat" "docker" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

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
   wl-clipboard
   wl-clip-persist
   cliphist
   wlr-randr
   bitwarden-cli
   jq
   gnupg
   openssh
   evtest
   alsa-utils
   zsh
   eza
   bat
   fzf
   ripgrep
   fd
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  security.sudo.wheelNeedsPassword = false;
  security.sudo.extraRules = [{
    users = [ "julien" ];
    commands = [{
      command = "/run/current-system/sw/bin/tee /sys/class/leds/platform\\:\\:micmute/brightness";
      options = [ "NOPASSWD" ];
    }];
  }];

  security.polkit.enable = true;
  services.dbus.enable = true;

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

  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec mango
    fi
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.dconf.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  system.stateVersion = "25.11";

}
