{ config, lib, pkgs, ... }:

{
  services.dbus.enable = true;
  services.printing.enable = true;
  services.fwupd.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon = {
    enable = true;
  };
  
  # Disable performance profile by default
  systemd.services.power-profiles-daemon.serviceConfig = {
    Environment = "PPD_DISABLE_PERFORMANCE=1";
  };
  
  services.getty.autologinUser = "julien";
  
  # Allow users to change power profiles without password
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "net.hadess.PowerProfiles.switch-profile" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
  
  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  
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
