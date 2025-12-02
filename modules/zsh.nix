{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    history = {
      size = 5000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };
    
    historySubstringSearch.enable = true;
    
    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      GPG_TTY = "$(tty)";
    };
    
    # Aliases
    shellAliases = {
      # General
      ls = "eza -a --icons=always";
      ll = "eza -al --icons=always";
      lt = "eza -a --tree --level=1 --icons=always";
      cat = "bat --style plain --theme=base16";
      vim = "nvim";
      c = "clear";
      man = "tldr";
      
      # System
      shutdown = "systemctl poweroff";
      
      # Docker power management
      don = "~/.local/bin/don";
      doff = "~/.local/bin/doff";
      dstatus = "systemctl status docker --no-pager -l";
    };
    
    # Shell configuration with Zinit and all integrations
    initContent = ''
      # Powerlevel10k instant prompt (must be at the top)
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      
      # Set the directory we want to store zinit and plugins
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      
      # Download Zinit, if it's not there yet
      if [ ! -d "$ZINIT_HOME" ]; then
         mkdir -p "$(dirname $ZINIT_HOME)"
         git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi
      
      # Source/Load zinit
      source "''${ZINIT_HOME}/zinit.zsh"
      
      # Add in Powerlevel10k
      zinit ice depth=1; zinit light romkatv/powerlevel10k
      
      # Add in zsh plugins
      zinit light zsh-users/zsh-syntax-highlighting
      zinit light zsh-users/zsh-completions
      zinit light zsh-users/zsh-autosuggestions
      zinit light Aloxaf/fzf-tab
      
      # Add in snippets
      zinit snippet OMZL::git.zsh
      zinit snippet OMZP::git
      zinit snippet OMZP::sudo
      zinit snippet OMZP::command-not-found
      
      # Load completions
      autoload -Uz compinit && compinit
      zinit cdreplay -q
      
      # Git wrapper to launch lazygit when no args
      git() {
        if [ -z "$1" ]; then
          lazygit
        else
          command git "$@"
        fi
      }
      
      # Docker wrapper to launch lazydocker when no args
      docker() {
        if [ -z "$1" ]; then
          lazydocker
        else
          command docker "$@"
        fi
      }
      
      # Neovim wrapper to adjust kitty padding
      nvim() {
        kitty @ set-spacing padding=0 margin=0 2>/dev/null || true
        command nvim "$@"
        kitty @ set-spacing padding=10 margin=0 2>/dev/null || true
      }
      
      # Keybindings
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region
      bindkey '^[[A' fzf-history-widget
      
      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
      
      # Shell integrations
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"
      
      # Mise activation
      eval "$(mise activate zsh)"
      
      # Load p10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Fastfetch on terminal start
      if [[ $(tty) == *"pts"* ]]; then
        fastfetch --config examples/13 --logo nixos 2>/dev/null || fastfetch
      fi
    '';
  };
  
  # Ensure zsh is the default shell
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
}

