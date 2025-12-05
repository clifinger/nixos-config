{ config, pkgs, ... }:

{
  # Install brightnessctl
  environment.systemPackages = with pkgs; [
    brightnessctl
    libnotify  # for notify-send
  ];

  # Enable power-profiles-daemon
  services.power-profiles-daemon.enable = true;

  # Allow brightnessctl to run without password for video group
  security.sudo.extraRules = [
    {
      users = [ "root" ];
      commands = [
        {
          command = "${pkgs.brightnessctl}/bin/brightnessctl";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

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
              
              # Use sudo to trigger DBus events that DankShell listens to
              ${pkgs.sudo}/bin/sudo ${pkgs.brightnessctl}/bin/brightnessctl set 80%
              
              # Send notification to user
              ${pkgs.su}/bin/su julien -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus ${pkgs.libnotify}/bin/notify-send -u low -t 2000 '⚡ AC Connected' 'Profile: Balanced • Brightness: 80%'"
              
              ${pkgs.util-linux}/bin/logger "Power: AC connected - switched to balanced profile with 80% brightness"
          else
              # AC unplugged: power-saver mode, 40% brightness
              ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
              
              # Use sudo to trigger DBus events that DankShell listens to
              ${pkgs.sudo}/bin/sudo ${pkgs.brightnessctl}/bin/brightnessctl set 40%
              
              # Send notification to user
              ${pkgs.su}/bin/su julien -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus ${pkgs.libnotify}/bin/notify-send -u low -t 2000 '🔋 Battery Mode' 'Profile: Power Saver • Brightness: 40%'"
              
              ${pkgs.util-linux}/bin/logger "Power: AC disconnected - switched to power-saver profile with 40% brightness"
          fi
        '';
      };
    };
  };
}
