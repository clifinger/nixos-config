{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "thinkpad_acpi" ];
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
}
