# Home Manager Configuration

Configuration Home Manager pour la gestion déclarative des dotfiles utilisateur.

## Structure

```
home-manager/
  home.nix          # Configuration principale Home Manager

modules/
  kitty.nix         # Configuration Kitty terminal
  zsh.nix           # Configuration Zsh avec Zinit et Powerlevel10k
```

## Fonctionnalités

### Kitty Terminal
- ✅ Police: Maple Mono Nerd Font
- ✅ Opacité et flou pour un look moderne
- ✅ Thème Electrify Purple personnalisé
- ✅ Raccourcis optimisés pour Wayland
- ✅ Integration avec Neovim (padding dynamique)

### Zsh
- ✅ Plugin manager: Zinit (auto-installation)
- ✅ Theme: Powerlevel10k
- ✅ Plugins:
  - zsh-syntax-highlighting
  - zsh-autosuggestions
  - zsh-completions
  - fzf-tab
  - Oh My Zsh snippets (git, sudo, etc.)
- ✅ Outils modernes:
  - `eza` (remplacement de ls)
  - `bat` (remplacement de cat)
  - `fzf` (fuzzy finder)
  - `zoxide` (smart cd)
  - `lazygit` & `lazydocker`
- ✅ Wrappers intelligents:
  - `git` → lance lazygit si pas d'arguments
  - `docker` → lance lazydocker si pas d'arguments
  - `nvim` → ajuste le padding de kitty automatiquement

### Packages installés automatiquement
- Outils CLI: eza, bat, fzf, zoxide, tldr, fastfetch, mise
- Git tools: lazygit, lazydocker
- Editeur: neovim
- Police: Maple Mono Nerd Font

## Installation

La configuration est automatiquement appliquée via le flake.nix principal.

```bash
# Reconstruire le système avec Home Manager
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#nixos

# Ou juste pour Home Manager
home-manager switch --flake .#julien@nixos
```

## Personnalisation

### Modifier la configuration Kitty

Editez `modules/kitty.nix` pour changer:
- Police et taille
- Couleurs et thème
- Opacité et effets
- Raccourcis clavier

### Modifier la configuration Zsh

Editez `modules/zsh.nix` pour:
- Ajouter/retirer des plugins Zinit
- Modifier les alias
- Ajouter des fonctions shell
- Changer les intégrations

### Ajouter des packages

Editez `home-manager/home.nix` et ajoutez dans `home.packages`.

## Powerlevel10k

Pour configurer Powerlevel10k:

```bash
p10k configure
```

Le fichier de configuration sera sauvegardé dans `~/.p10k.zsh` et sera automatiquement chargé.

## Mise à jour

```bash
# Mettre à jour les flakes
nix flake update

# Appliquer les changements
sudo nixos-rebuild switch --flake .#nixos
```

## Notes

- La configuration est purement déclarative - pas besoin de stow ou install.sh
- Zinit et les plugins sont installés automatiquement au premier lancement de zsh
- Les fonts sont gérées par Home Manager et disponibles automatiquement
- GPG et Git sont configurés avec signature automatique des commits
