{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system/boot.nix
    ./system/networking.nix
    ./system/audio.nix
    ./system/bluetooth.nix
    ./system/security.nix
    ./system/services.nix
    ./system/thinkpad.nix
    ./system/virtualization.nix
    ./system/power-management.nix
    ./system/wayland.nix
  ];

  networking.hostName = "nixos";

  time.timeZone = "Asia/Manila";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  console.keyMap = "us";

  users.users.julien = {
    isNormalUser = true;
    description = "Julien Lenne";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "seat" "docker" "vmware" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim nano git wget curl
    github-cli github-copilot-cli
    (chromium.override {
      enableWideVine = true;
    })
    kitty foot
    wl-clipboard wl-clip-persist cliphist wlr-randr
    bitwarden-cli jq gnupg openssh exercism
    evtest alsa-utils
    zsh eza bat fzf ripgrep fd
    cloudflared
    (pkgs.writeScriptBin "don" ''
      #!/usr/bin/env bash
      sudo systemctl start docker.socket docker.service
      echo "Docker started"
    '')
    (pkgs.writeScriptBin "doff" ''
      #!/usr/bin/env bash
      sudo systemctl stop docker.socket docker.service
      echo "Docker stopped"
    '')
  ];

  system.stateVersion = "25.11";
}
