# NixOS Configuration

Configuration NixOS personnelle de Julien Lenne.

## Structure

- `configuration.nix` - Configuration système principale
- `hardware-configuration.nix` - Configuration matérielle
- `flake.nix` - Configuration Flakes
- `scripts/bitwarden-keys/` - Scripts de gestion des clés SSH/GPG via Bitwarden

## Installation

### Appliquer la configuration

```bash
sudo cp configuration.nix /etc/nixos/
sudo cp hardware-configuration.nix /etc/nixos/
sudo nixos-rebuild switch
```

### Restaurer les clés SSH/GPG

```bash
./scripts/bitwarden-keys/restore-keys-auto.sh
```

## Fonctionnalités

- ✅ Kernel Linux latest
- ✅ Wayland (MangoWC compositor)
- ✅ PipeWire pour l'audio
- ✅ GPG agent avec support SSH
- ✅ Bitwarden CLI pour gestion des clés
- ✅ GitHub CLI & Copilot CLI
- ✅ Flakes activés

## Scripts

### Gestion des clés

- `scripts/bitwarden-keys/restore-keys-auto.sh` - Restaure ou génère des clés SSH/GPG
- `scripts/bitwarden-keys/restore-keys.sh` - Restaure les clés depuis Bitwarden
- `scripts/bitwarden-keys/backup-keys.sh` - Sauvegarde les clés dans Bitwarden

## Packages installés

- Éditeurs: vim, nano
- Développement: git, github-cli, github-copilot-cli
- Outils: wget, curl, jq
- Navigateur: chromium
- Terminaux: kitty, foot
- Wayland: wl-clipboard, wlr-randr
- Sécurité: bitwarden-cli, gnupg, openssh
