{ config, pkgs, ... }:

{
  # Install brightnessctl
  environment.systemPackages = with pkgs; [
    brightnessctl
    libnotify  # for notify-send
  ];

  # Enable power-profiles-daemon
  services.power-profiles-daemon.enable = true;

  # Allow users in video group to change brightness without sudo
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w $sys$devpath/brightness"
  '';

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
              
              # Run as user julien to update DankShell UI
              ${pkgs.su}/bin/su julien -c "${pkgs.brightnessctl}/bin/brightnessctl set 80%"
              
              # Send notification to user
              ${pkgs.su}/bin/su julien -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus ${pkgs.libnotify}/bin/notify-send -u low -t 2000 '⚡ AC Connected' 'Profile: Balanced • Brightness: 80%'"
              
              ${pkgs.util-linux}/bin/logger "Power: AC connected - switched to balanced profile with 80% brightness"
          else
              # AC unplugged: power-saver mode, 40% brightness
              ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
              
              # Run as user julien to update DankShell UI
              ${pkgs.su}/bin/su julien -c "${pkgs.brightnessctl}/bin/brightnessctl set 40%"
              
              # Send notification to user
              ${pkgs.su}/bin/su julien -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus ${pkgs.libnotify}/bin/notify-send -u low -t 2000 '🔋 Battery Mode' 'Profile: Power Saver • Brightness: 40%'"
              
              ${pkgs.util-linux}/bin/logger "Power: AC disconnected - switched to power-saver profile with 40% brightness"
          fi
        '';
      };
    };
  };
}
