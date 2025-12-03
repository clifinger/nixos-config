{ config, pkgs, ... }:

let
  maple-font = pkgs.callPackage ../modules/maple-font.nix {};
in
{
  imports = [
    ../modules/kitty.nix
    ../modules/zsh.nix
    ../modules/neovim.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "julien";
  home.homeDirectory = "/home/julien";
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # CLI tools
    eza           # Modern ls replacement
    bat           # Better cat with syntax highlighting
    fzf           # Fuzzy finder
    zoxide        # Smart cd command
    tldr          # Simplified man pages
    fastfetch     # System info display
    mise          # Runtime version manager
    lazygit       # Terminal UI for git
    lazydocker    # Terminal UI for docker
    git           # Git version control
    
    # Fonts - Maple Mono Nerd Font (custom package)
    maple-font
    nerd-fonts.symbols-only
    
    # Development tools
    # neovim now configured in modules/neovim.nix
    
    # File manager
    nautilus      # GNOME file manager
    
    # Screenshot tools
    grim          # Wayland screenshot tool
    slurp         # Select region on Wayland
    wl-clipboard  # Wayland clipboard utilities
    libnotify     # notify-send for notifications
  ];

  # Font configuration
  fonts.fontconfig.enable = true;
  
  # GTK configuration pour le curseur
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };
  
  # DConf
  dconf.enable = true;
  
  # XDG user directories (Documents, Downloads, etc.)
  xdg.userDirs = {
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
  
  # GTK bookmarks pour Nautilus
  gtk.gtk3.bookmarks = [
    "file://${config.home.homeDirectory}/Documents"
    "file://${config.home.homeDirectory}/Downloads"
    "file://${config.home.homeDirectory}/Music"
    "file://${config.home.homeDirectory}/Pictures"
    "file://${config.home.homeDirectory}/Videos"
  ];
  
  # Pointer cursor
  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };
  
  # Git configuration
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
  
  # GPG
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
  };
}
