{ config, pkgs, ... }:

{
  programs.neovim.enable = true;
  
  home.packages = with pkgs; [
    gcc
    gnumake
    unzip
    readline
    lua51Packages.luarocks-nix
    ripgrep
    fd
    lazygit
    tree-sitter
    nodejs
    python3
    go
    cargo
    rustc
    ueberzugpp
    imagemagick
    mise
  ];
}
