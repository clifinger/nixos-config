{ config, pkgs, ... }:

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
              ${pkgs.su}/bin/su - julien -c "XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus /etc/profiles/per-user/julien/bin/dms ipc call brightness set 80 'backlight:amdgpu_bl1'"
              ${pkgs.util-linux}/bin/logger "Power: AC connected - switched to balanced profile with 80% brightness"
          else
              # AC unplugged: power-saver mode, 40% brightness
              ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
              ${pkgs.su}/bin/su - julien -c "XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus /etc/profiles/per-user/julien/bin/dms ipc call brightness set 40 'backlight:amdgpu_bl1'"
              ${pkgs.util-linux}/bin/logger "Power: AC disconnected - switched to power-saver profile with 40% brightness"
          fi
        '';
      };
    };
  };
}
