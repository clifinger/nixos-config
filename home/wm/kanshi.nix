# Kanshi monitor configuration
{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    
    systemdTarget = "graphical-session.target";
    
    settings = [
      # Profile: Dual monitor (HP Z27n 2K + Xiaomi 4K)
      {
        profile.name = "dual-hp-xiaomi";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited 0x41B0 Unknown";
            status = "disable";
          }
          {
            criteria = "Hewlett Packard HP Z27n CNK72307H3";
            scale = 1.0;
            mode = "2560x1440@59.951Hz";
            position = "0,0";
            status = "enable";
          }
          {
            criteria = "Xiaomi Corporation Mi Monitor 6638000002298";
            scale = 1.5;
            mode = "3840x2160@60Hz";
            position = "2560,0";
            status = "enable";
          }
        ];
      }
      
      # Profile: HP Z27n 2K monitor only
      {
        profile.name = "hp-2k";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited 0x41B0 Unknown";
            status = "disable";
          }
          {
            criteria = "Hewlett Packard HP Z27n CNK72307H3";
            scale = 1.0;
            mode = "2560x1440@59.951Hz";
            position = "0,0";
            status = "enable";
          }
        ];
      }
      
      # Profile: Xiaomi 4K monitor only
      {
        profile.name = "xiaomi-4k";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited 0x41B0 Unknown";
            status = "disable";
          }
          {
            criteria = "Xiaomi Corporation Mi Monitor 6638000002298";
            scale = 1.5;
            mode = "3840x2160@60Hz";
            position = "0,0";
            status = "enable";
          }
        ];
      }
      
      # Profile: Laptop only (fallback - no external monitors)
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited 0x41B0 Unknown";
            scale = 1.3;
            mode = "2560x1600@60Hz";
            position = "0,0";
            status = "enable";
          }
        ];
      }
    ];
  };
}
