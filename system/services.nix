{ config, lib, pkgs, ... }:

{
  services.dbus.enable = true;
  services.printing.enable = true;
  services.fwupd.enable = true;
  services.upower.enable = true;
  services.getty.autologinUser = "julien";
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  
  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec mango
    fi
  '';
  
  programs.dconf.enable = true;
}
