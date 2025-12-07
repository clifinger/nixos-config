{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  virtualisation.vmware.host = {
    enable = true;
    package = pkgs.vmware-workstation;
  };
}
