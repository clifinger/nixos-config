{ config, pkgs, ... }:

{
  imports = [
    ./modules/kitty.nix
    ./modules/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "julien";
  home.homeDirectory = "/home/julien";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Packages that should be installed to the user profile
  home.packages = with pkgs; [
    # CLI tools
    eza           # Modern ls replacement
    bat           # Better cat
    fzf           # Fuzzy finder
    zoxide        # Smart cd
    tldr          # Simplified man pages
    fastfetch     # System info
    mise          # Runtime version manager
    lazygit       # Terminal UI for git
    lazydocker    # Terminal UI for docker
    git           # Git version control
    
    # Fonts - Maple Mono with Nerd Font icons
    maple-mono.NF
    
    # Development tools (from your dotfiles)
    neovim
  ];

  # Font configuration
  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  
  # Git configuration (already set globally but good to have here)
  programs.git = {
    enable = true;
    userName = "Julien Lenne";
    userEmail = "contact.lenne@gmail.com";
    signing = {
      key = "2944C14E29F0B7A2";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      tag.gpgsign = true;
    };
  };
  
  # GPG
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
