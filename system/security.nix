{ config, lib, pkgs, ... }:

{
  security.polkit.enable = true;
  
  security.sudo = {
    wheelNeedsPassword = false;
    extraRules = [{
      groups = [ "wheel" ];
      commands = [{
        command = "/run/current-system/sw/bin/tee /sys/class/leds/platform\\:\\:micmute/brightness";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
