{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    extraPackages = with pkgs; [
      # Build essentials
      gcc
      gnumake
      unzip
      readline
      
      # Lua and LuaRocks for magick
      lua51Packages.luarocks-nix
      
      # Search tools
      ripgrep
      fd
      
      # Git UI
      lazygit
      
      # Tree-sitter
      tree-sitter
      
      # Runtimes needed by Mason
      nodejs
      python3
      go
      cargo
      rustc
      
      # Image preview for Telescope
      ueberzugpp
      imagemagick
      
      # Version manager for additional tools
      mise
    ];
  };
  
  # Clone your nvim config
  home.activation.cloneNvimConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
      ${pkgs.git}/bin/git clone git@github.com:clifinger/nvim-for-dev.git ${config.home.homeDirectory}/.config/nvim
    fi
  '';
}
