{ config, pkgs, ... }:

let
  powerProfileScript = pkgs.writeShellScriptBin "power-profile-switch" ''
    # Get AC adapter status
    AC_STATUS=$(cat /sys/class/power_supply/AC/online)

    if [ "$AC_STATUS" -eq 1 ]; then
        # AC plugged in: balanced mode, 80% brightness
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
        ${pkgs.brightnessctl}/bin/brightnessctl set 80%
        ${pkgs.util-linux}/bin/logger "Power: AC connected - switched to balanced profile with 80% brightness"
    else
        # AC unplugged: power-saver mode, 40% brightness
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
        ${pkgs.brightnessctl}/bin/brightnessctl set 40%
        ${pkgs.util-linux}/bin/logger "Power: AC disconnected - switched to power-saver profile with 40% brightness"
    fi
  '';
in
{
  # Copy power profile switch script
  environment.systemPackages = with pkgs; [
    brightnessctl
    powerProfileScript
  ];

  # Udev rule to detect AC adapter changes
  services.udev.extraRules = ''
    # Detect AC adapter changes and switch power profile + brightness
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${powerProfileScript}/bin/power-profile-switch"
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${powerProfileScript}/bin/power-profile-switch"
  '';

  # Enable power-profiles-daemon
  services.power-profiles-daemon.enable = true;
}
