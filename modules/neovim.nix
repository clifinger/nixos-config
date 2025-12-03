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
      
      # Search tools
      ripgrep
      fd
      
      # Language servers (LSP)
      # Python
      pyright
      ruff-lsp
      
      # JavaScript/TypeScript
      typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted # HTML/CSS/JSON
      tailwindcss-language-server
      
      # Rust
      rust-analyzer
      
      # Zig
      zls
      
      # Go
      gopls
      delve # Go debugger
      
      # YAML/TOML
      yaml-language-server
      taplo # TOML LSP
      
      # Markdown
      marksman
      
      # Lua
      lua-language-server
      stylua
      
      # Formatters and linters
      nodePackages.prettier
      black
      isort
      shfmt
      
      # Tools
      lazygit
      tree-sitter
    ];
  };
  
  # Clone your nvim config
  home.activation.cloneNvimConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
      ${pkgs.git}/bin/git clone https://github.com/clifinger/nvim-for-dev.git ${config.home.homeDirectory}/.config/nvim
    fi
  '';
}
