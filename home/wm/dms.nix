{ inputs, outputs, lib, config, pkgs, ... }:

{
  programs.dankMaterialShell = {
    enable = true;
    systemd.enable = true;
  };
}
