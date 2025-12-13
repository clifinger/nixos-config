{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    
    settings = {
      format = lib.concatStrings [
        "$os"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$character"
      ];
      
      add_newline = true;
      
      os = {
        disabled = false;
        format = "[$symbol ]($style)";
        style = "bold blue";
        symbols = {
          NixOS = "";
        };
      };
      
      directory = {
        format = "[$path]($style) ";
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
      };
      
      git_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
        symbol = " ";
      };
      
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?";
        stashed = "\\$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };
      
      nix_shell = {
        disabled = false;
        format = "[$symbol$name]($style) ";
        symbol = "❄ ";
        style = "bold yellow";
      };
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
        style = "bold yellow";
      };
    };
  };
}
