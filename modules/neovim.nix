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
      
      # Version manager for additional tools
      mise
    ];
  };
  
  # Clone your nvim config
  home.activation.cloneNvimConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
      ${pkgs.git}/bin/git clone https://github.com/clifinger/nvim-for-dev.git ${config.home.homeDirectory}/.config/nvim
    fi
  '';
}
