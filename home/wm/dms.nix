{ inputs, outputs, lib, config, pkgs, ... }:

{
  programs.dankMaterialShell = {
    enable = true;
    systemd.enable = true;
  };
  
  # Fix PATH for systemd service
  systemd.user.services.dms = {
    Service = {
      Environment = "PATH=/etc/profiles/per-user/julien/bin:/run/current-system/sw/bin:/usr/bin:/bin";
    };
  };
}
