{ config, pkgs, lib, ... }:

let
  # Get the first normal user (UID >= 1000)
  normalUsers = lib.filterAttrs (n: u: u.isNormalUser) config.users.users;
  mainUser = lib.head (lib.attrNames normalUsers);
  mainUserConfig = config.users.users.${mainUser};
  userUid = toString mainUserConfig.uid;
in
{
  # Install brightnessctl
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  # Enable power-profiles-daemon
  services.power-profiles-daemon.enable = true;

  # Enable acpid to handle power events
  services.acpid = {
    enable = true;
    handlers = {
      ac-power = {
        event = "ac_adapter.*";
        action = ''
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
      };
    };
  };
}
