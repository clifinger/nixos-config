{ config, pkgs, ... }:

{
  imports = [
    ../modules/kitty.nix
    ../modules/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "julien";
  home.homeDirectory = "/home/julien";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
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
  
  # Git configuration (already set globally but good to have here)
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Julien Lenne";
        email = "contact.lenne@gmail.com";
      };
      commit.gpgsign = true;
      tag.gpgsign = true;
      init.defaultBranch = "main";
      user.signingkey = "2944C14E29F0B7A2";
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
