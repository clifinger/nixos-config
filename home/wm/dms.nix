{ inputs, outputs, lib, config, pkgs, ... }:

{
  programs.dankMaterialShell = {
    enable = true;
    systemd.enable = false;  # Disabled - started from Mango autostart instead
  };
}
