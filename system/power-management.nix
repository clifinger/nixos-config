{ config, lib, pkgs, ... }:

let
  normalUsers = lib.filterAttrs (n: u: u.isNormalUser) config.users.users;
  mainUser = lib.head (lib.attrNames normalUsers);
  mainUserConfig = config.users.users.${mainUser};
  userUid = toString mainUserConfig.uid;
in
{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.power-profiles-daemon.enable = true;

  services.acpid = {
    enable = true;
    handlers = {
      ac-power = {
        event = "ac_adapter.*";
        action = ''
          AC_STATUS=$(cat /sys/class/power_supply/AC/online)
          
          if [ "$AC_STATUS" -eq 1 ]; then
              ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
              ${pkgs.brightnessctl}/bin/brightnessctl set 80%
              ${pkgs.util-linux}/bin/logger "Power: AC connected - balanced profile, 80% brightness"
          else
              ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
              ${pkgs.brightnessctl}/bin/brightnessctl set 40%
              ${pkgs.util-linux}/bin/logger "Power: AC disconnected - power-saver profile, 40% brightness"
          fi
        '';
      };
    };
  };
}
