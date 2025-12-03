# User configuration for julien
{ inputs, outputs, lib, config, pkgs, ... }:

let
  maple-font = pkgs.callPackage ../../home/programs/maple-font.nix {};
in
{
  imports = [
    ../../home/programs/kitty.nix
    ../../home/programs/zsh.nix
    ../../home/programs/neovim.nix
    ../../home/wm/mango.nix
    ../../home/wm/dms.nix
  ];

  home = {
    username = "julien";
    homeDirectory = "/home/julien";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    eza bat fzf zoxide tldr fastfetch mise
    lazygit lazydocker git
    maple-font nerd-fonts.symbols-only
    nautilus grim slurp wl-clipboard libnotify
  ];

  home.file.".config/nix-shells/haskell.nix".text = ''
    { pkgs ? import <nixpkgs> {} }:

    pkgs.mkShell {
      buildInputs = with pkgs; [
        ghc
        cabal-install
        haskell-language-server
        haskellPackages.fourmolu
        haskellPackages.hlint
        haskellPackages.hoogle
        zlib
        pkg-config
      ];

      shellHook = '''
        if [ -n "$ZSH_VERSION" ]; then
          export PROMPT="%F{cyan}via%f %F{green}λ haskell%f $PROMPT"
        elif [ -n "$BASH_VERSION" ]; then
          export PS1="\[\033[1;36m\]via\[\033[0m\] \[\033[1;32m\]λ haskell\[\033[0m\] $PS1"
        fi
        
        echo "Haskell development environment"
        echo "=============================="
        echo "GHC:   $(ghc --numeric-version)"
        echo "Cabal: $(cabal --numeric-version)"
        echo ""
        echo "Tools: ghc, cabal, hls, fourmolu, hlint, hoogle"
        echo ""
      ''';
    }
  '';

  home.file.".local/bin/haskell-shell" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      nix-shell ~/.config/nix-shells/haskell.nix --run $SHELL
    '';
  };

  fonts.fontconfig.enable = true;
  dconf.enable = true;
  
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/Documents"
      "file://${config.home.homeDirectory}/Downloads"
      "file://${config.home.homeDirectory}/Music"
      "file://${config.home.homeDirectory}/Pictures"
      "file://${config.home.homeDirectory}/Videos"
    ];
  };
  
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };
  };
  
  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Julien Lenne";
        email = "contact.lenne@gmail.com";
        signingkey = "2944C14E29F0B7A2";
      };
      commit.gpgsign = true;
      tag.gpgsign = true;
      init.defaultBranch = "main";
    };
  };
  
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
  };
}
