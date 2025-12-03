{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    
    # Completion configuration
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    
    # History configuration
    history = {
      size = 5000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      save = 5000;
      extended = true;
    };
    
    # Default options
    defaultKeymap = "emacs";
    
    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      GPG_TTY = "$(tty)";
      XCURSOR_SIZE = "36";  # 24 * 1.5 scale
    };
    
    # Shell aliases
    shellAliases = {
      # Modern CLI replacements
      ls = "eza -a --icons=always";
      ll = "eza -al --icons=always";
      lt = "eza -a --tree --level=1 --icons=always";
      cat = "bat --style plain --theme=base16";
      vim = "nvim";
      c = "clear";
      man = "tldr";
      
      # System management
      shutdown = "systemctl poweroff";
      
      # Docker power management (optional scripts)
      don = "~/.local/bin/don";
      doff = "~/.local/bin/doff";
      dstatus = "systemctl status docker --no-pager -l";
    };
    
    # Additional shell configuration
    initExtra = ''
      # Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      
      # Zinit plugin manager setup
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      
      if [ ! -d "$ZINIT_HOME" ]; then
         mkdir -p "$(dirname $ZINIT_HOME)"
         git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi
      
      source "''${ZINIT_HOME}/zinit.zsh"
      
      # Powerlevel10k theme
      zinit ice depth=1; zinit light romkatv/powerlevel10k
      
      # Essential zsh plugins
      zinit light zsh-users/zsh-syntax-highlighting
      zinit light zsh-users/zsh-completions
      zinit light zsh-users/zsh-autosuggestions
      zinit light Aloxaf/fzf-tab
      
      # Oh-My-Zsh snippets
      zinit snippet OMZL::git.zsh
      zinit snippet OMZP::git
      zinit snippet OMZP::sudo
      zinit snippet OMZP::command-not-found
      
      # Reload completions
      autoload -Uz compinit && compinit
      zinit cdreplay -q
      
      # Custom functions
      
      # Git wrapper: launch lazygit when called without arguments
      git() {
        if [ -z "$1" ]; then
          lazygit
        else
          command git "$@"
        fi
      }
      
      # Docker wrapper: launch lazydocker when called without arguments
      docker() {
        if [ -z "$1" ]; then
          lazydocker
        else
          command docker "$@"
        fi
      }
      
      # Neovim wrapper: adjust kitty padding dynamically
      nvim() {
        kitty @ set-spacing padding=0 margin=0 2>/dev/null || true
        command nvim "$@"
        kitty @ set-spacing padding=10 margin=0 2>/dev/null || true
      }
      
      # Keybindings
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region
      bindkey '^[[A' fzf-history-widget
      
      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color $realpath'
      
      # Shell integrations
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"
      eval "$(mise activate zsh)"
      
      # Load Powerlevel10k configuration
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Display fastfetch on new terminal
      if [[ $(tty) == *"pts"* ]]; then
        fastfetch --config examples/13 --logo nixos 2>/dev/null || fastfetch 2>/dev/null || true
      fi
    '';
  };
  
  # XDG directories
  xdg.enable = true;
}

