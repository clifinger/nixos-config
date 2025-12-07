{ config, pkgs, ... }:

{
  programs.neovim.enable = true;
  
  home.packages = with pkgs; [
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
}
