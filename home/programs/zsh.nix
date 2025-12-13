{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    
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
    
    defaultKeymap = "emacs";
    
    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
    
    sessionVariables = {
      EDITOR = "nvim";
      GPG_TTY = "$(tty)";
      XCURSOR_SIZE = "36";
    };
    
    shellAliases = {
      ls = "eza -a --icons=always";
      ll = "eza -al --icons=always";
      lt = "eza -a --tree --level=1 --icons=always";
      cat = "bat --style plain --theme=base16";
      vim = "nvim";
      c = "clear";
      man = "tldr";
      shutdown = "systemctl poweroff";
      rebuild = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#nixos";
      dstatus = "systemctl status docker --no-pager -l";
    };
    
    initContent = ''
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      
      if [ ! -d "$ZINIT_HOME" ]; then
         mkdir -p "$(dirname $ZINIT_HOME)"
         git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi
      
      source "''${ZINIT_HOME}/zinit.zsh"
      
      zinit ice depth=1; zinit light romkatv/powerlevel10k
      zinit light zsh-users/zsh-syntax-highlighting
      zinit light zsh-users/zsh-completions
      zinit light zsh-users/zsh-autosuggestions
      zinit light Aloxaf/fzf-tab
      
      zinit snippet OMZL::git.zsh
      zinit snippet OMZP::git
      zinit snippet OMZP::sudo
      zinit snippet OMZP::command-not-found
      
      autoload -Uz compinit && compinit
      zinit cdreplay -q
      
      git() {
        if [ -z "$1" ]; then
          lazygit
        else
          command git "$@"
        fi
      }
      
      docker() {
        if [ -z "$1" ]; then
          lazydocker
        else
          command docker "$@"
        fi
      }
      
      nvim() {
        kitty @ set-spacing padding=0 margin=0 2>/dev/null || true
        command nvim "$@"
        kitty @ set-spacing padding=10 margin=0 2>/dev/null || true
      }
      
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region
      bindkey '^[[A' fzf-history-widget
      
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color $realpath'
      
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"
      eval "$(mise activate zsh)"
      
      function prompt_nix_shell() {
        if [[ -n "$IN_NIX_SHELL" ]]; then
          local shell_name="''${NIX_SHELL_NAME:-nix-shell}"
          local shell_type="$IN_NIX_SHELL"
          p10k segment -f 208 -i '❄' -t "$shell_name $shell_type"
        fi
      }
      
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      function show_fastfetch_once() {
        if [[ -z "$IN_NIX_SHELL" ]]; then
          fastfetch --config examples/13 --logo nixos --pipe false 2>/dev/null || fastfetch --pipe false 2>/dev/null || true
        fi
        precmd_functions=("''${precmd_functions[@]:#show_fastfetch_once}")
      }
      
      precmd_functions+=(show_fastfetch_once)
    '';
  };
  
  xdg.enable = true;
}
