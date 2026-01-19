{ config, pkgs, ... }:

{
  # Enable nix-ld to run dynamically linked binaries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Common libraries needed by dynamically linked executables
      stdenv.cc.cc
      zlib
      openssl
      curl
      glib
      gtk3
      cairo
      pango
      atk
      gdk-pixbuf
      libnotify
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb
      mesa
      libdrm
      expat
      libxkbcommon
      alsa-lib
      dbus
      nspr
      nss
      cups
    ];
  };
}
