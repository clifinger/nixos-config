# NixOS Configuration

Configuration NixOS personnelle de Julien Lenne avec Home Manager.

## 🎯 Vue d'ensemble

Configuration déclarative complète pour NixOS avec :
- **Compositeur Wayland** : MangoWC avec DankMaterialShell
- **Home Manager** : Gestion déclarative des dotfiles utilisateur
- **Terminal** : Kitty avec thème Electrify Purple
- **Shell** : Zsh avec Powerlevel10k et Zinit
- **Outils modernes** : eza, bat, fzf, zoxide, lazygit, lazydocker

## 📁 Structure

```
nixos-config/
├── configuration.nix           # Configuration système NixOS
├── hardware-configuration.nix  # Configuration matérielle
├── flake.nix                   # Flake principal avec Home Manager
├── flake.lock                  # Lock file des dépendances
├── home-manager/
│   ├── home.nix               # Configuration Home Manager principale
│   └── README.md              # Documentation Home Manager
├── modules/
│   ├── kitty.nix              # Module Kitty (terminal)
│   └── zsh.nix                # Module Zsh (shell)
└── scripts/
    └── bitwarden-keys/        # Scripts de gestion des clés SSH/GPG
        ├── backup-keys.sh
        ├── restore-keys-auto.sh
        └── restore-keys.sh
```

## 🚀 Installation initiale

### 1. Cloner le repository

```bash
git clone https://github.com/clifinger/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

### 2. Appliquer la configuration

```bash
# Copier les fichiers de configuration système
sudo cp configuration.nix hardware-configuration.nix flake.nix flake.lock /etc/nixos/

# Rebuild avec le flake
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```

### 3. Restaurer les clés SSH/GPG (optionnel)

```bash
# Se connecter à Bitwarden CLI
bw login

# Restaurer ou générer les clés
~/nixos-config/scripts/bitwarden-keys/restore-keys-auto.sh
```

## 🔄 Mise à jour

```bash
cd ~/nixos-config

# Mettre à jour le flake.lock
nix flake update

# Appliquer les changements
sudo nixos-rebuild switch --flake .#nixos
```

## ✨ Fonctionnalités

### Système

- ✅ Kernel Linux latest
- ✅ Wayland avec MangoWC compositor
- ✅ PipeWire pour l'audio
- ✅ NetworkManager pour le réseau
- ✅ GPG agent avec support SSH intégré
- ✅ Flakes activés
- ✅ Sudo sans mot de passe pour wheel

### Terminal (Kitty)

- ✅ Police : Maple Mono Nerd Font 12pt
- ✅ Opacité et flou (92% opacity, blur 99)
- ✅ Thème Electrify Purple personnalisé
- ✅ Raccourcis optimisés pour Wayland
- ✅ Support du cursor trail
- ✅ Integration Neovim (padding dynamique)

### Shell (Zsh)

- ✅ Plugin manager : Zinit (auto-installation)
- ✅ Thème : Powerlevel10k
- ✅ Plugins :
  - zsh-syntax-highlighting
  - zsh-autosuggestions  
  - zsh-completions
  - fzf-tab
  - Oh My Zsh snippets
- ✅ Outils CLI modernes :
  - `eza` → `ls` moderne avec icônes
  - `bat` → `cat` avec coloration syntaxique
  - `fzf` → fuzzy finder
  - `zoxide` → `cd` intelligent
  - `lazygit` → TUI Git
  - `lazydocker` → TUI Docker
  - `mise` → version manager
- ✅ Wrappers intelligents :
  - `git` sans args → lance lazygit
  - `docker` sans args → lance lazydocker
  - `nvim` → ajuste padding Kitty

### Gestion des clés

- ✅ Backup/restore SSH et GPG via Bitwarden CLI
- ✅ Génération automatique de nouvelles clés
- ✅ Configuration Git avec signature GPG
- ✅ Scripts dédiés dans `scripts/bitwarden-keys/`

## 📦 Packages installés

### Système
- vim, nano, git, wget, curl
- github-cli, github-copilot-cli
- chromium, kitty, foot
- wl-clipboard, wlr-randr
- bitwarden-cli, jq, gnupg, openssh

### Utilisateur (via Home Manager)
- eza, bat, fzf, zoxide, tldr
- fastfetch, mise
- lazygit, lazydocker
- neovim
- Maple Mono Nerd Font

## ⚙️ Configuration personnalisée

### Modifier Kitty

Éditez `modules/kitty.nix` pour personnaliser :
- Police et taille
- Couleurs et thème
- Opacité et effets visuels
- Raccourcis clavier

### Modifier Zsh

Éditez `modules/zsh.nix` pour :
- Ajouter/retirer plugins Zinit
- Modifier alias
- Ajouter fonctions shell
- Configurer intégrations CLI

### Ajouter des packages

Éditez `home-manager/home.nix`, section `home.packages`.

## 🎨 Powerlevel10k

Pour reconfigurer le thème du prompt :

```bash
p10k configure
```

Le fichier `~/.p10k.zsh` sera créé et chargé automatiquement.

## 🔧 Développement

### Vérifier la configuration

```bash
cd ~/nixos-config
nix flake check
```

### Tester sans appliquer

```bash
sudo nixos-rebuild build --flake .#nixos
```

### Voir les différences

```bash
nix flake diff
```

## 📝 Notes

- Configuration 100% déclarative - aucun fichier manuel à gérer
- Zinit et plugins installés automatiquement au premier lancement zsh
- Fonts gérées par Home Manager
- Git configuré pour signer automatiquement commits et tags
- GPG agent démarre automatiquement avec support SSH

## 🔗 Liens

- Repository : https://github.com/clifinger/nixos-config
- MangoWC : https://github.com/DreamMaoMao/mangowc
- DankMaterialShell : https://github.com/AvengeMedia/DankMaterialShell
- Home Manager : https://github.com/nix-community/home-manager

