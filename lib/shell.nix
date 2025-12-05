{ pkgs ? import <nixpkgs> {} }:

{
  mkDevShell = { buildInputs, name, toolsInfo }:
    pkgs.mkShell {
      inherit buildInputs;
      
      shellHook = ''
        echo "${name} development environment"
        echo "=============================="
        ${toolsInfo}
        echo ""
        
        if [ -n "$ZSH_VERSION" ]; then
          return
        fi
        exec zsh
      '';
    };
}

