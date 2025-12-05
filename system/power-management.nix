{ config, pkgs, ... }:

{
  # Copy power profile switch script
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  # Udev rule to detect AC adapter changes
  services.udev.extraRules = ''
    # Detect AC adapter changes and switch power profile + brightness
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.bash}/bin/bash /etc/nixos/power-profile-switch.sh"
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.bash}/bin/bash /etc/nixos/power-profile-switch.sh"
  '';

  # Enable power-profiles-daemon
  services.power-profiles-daemon.enable = true;

  # Copy the power profile switch script to /etc/nixos
  environment.etc."nixos/power-profile-switch.sh" = {
    source = ./scripts/power-profile-switch.sh;
    mode = "0755";
  };
}
