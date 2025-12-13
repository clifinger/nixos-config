# NixOS Configuration

Personal NixOS config with MangoWC compositor, Starship prompt, and home-manager.

## Features

- **Compositor:** MangoWC (Wayland)
- **Shell:** Zsh + Starship (Rust, fast)
- **Terminal:** Kitty
- **Editor:** Neovim
- **Hardware:** ThinkPad E16 Gen 1 (AMD)

## Install This Config

**Prerequisites:** NixOS already installed with flakes enabled.

```bash
# Backup your current config
sudo mv /etc/nixos /etc/nixos.backup

# Clone this repo
sudo git clone https://github.com/clifinger/nixos-config.git /etc/nixos
cd /etc/nixos

# Generate your hardware config
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# Review and adjust users/julien/default.nix if needed

# Apply the configuration
sudo nixos-rebuild switch --flake .#nixos

# Set your password
passwd

# Reboot
reboot
```

## Daily Usage

### Rebuild After Changes

```bash
rebuild  # alias for: sudo nixos-rebuild switch --flake .#nixos
```

### Update Dependencies

```bash
cd /etc/nixos
nix flake update
rebuild
```

### Add a Package

**System-wide** (available to all users):
```nix
# Edit hosts/nixos/default.nix
environment.systemPackages = with pkgs; [
  your-package
];
```

**User-only** (just for your user):
```nix
# Edit users/julien/default.nix
home.packages = with pkgs; [
  your-package
];
```

Then `rebuild`.

## Structure

```
.
├── flake.nix                  # Entry point
├── flake.lock                 # Locked dependency versions
├── hardware-configuration.nix # Auto-generated (your hardware)
│
├── hosts/nixos/              # System config for this machine
│   └── default.nix          # Imports from system/
│
├── system/                   # System modules (split by topic)
│   ├── boot.nix
│   ├── networking.nix
│   ├── audio.nix
│   └── ...
│
├── users/julien/             # Your home-manager config
│   └── default.nix          # Imports from home/
│
├── home/                     # Reusable home-manager modules
│   ├── programs/            # zsh, kitty, nvim, starship
│   ├── wm/                  # mango, dms
│   └── services/
│
├── desktop/                  # Desktop environment settings
└── scripts/                  # Helper scripts (don, doff, etc)
```

**Why `hosts/nixos/`?** Allows adding more machines later (desktop, server) while sharing modules from `system/` and `home/`.

## Customize

### Zsh Config
Edit `home/programs/zsh.nix` then `rebuild`.

### Starship Prompt
Edit `home/programs/starship.nix` then `rebuild`.

### System Settings
Edit files in `system/` then `rebuild`.

## Troubleshooting

**Check for errors:**
```bash
nix flake check
```

**Rollback to previous version:**
```bash
sudo nixos-rebuild switch --rollback
```

**List all generations:**
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

**Clean old generations:**
```bash
sudo nix-collect-garbage --delete-older-than 7d
```

## Notes

- Auto-login enabled (getty)
- Sudo without password for wheel group
- Docker disabled by default (use `don`/`doff` commands)
- Xanmod kernel for better performance

---

**NixOS:** 26.05 Unstable  
**State Version:** 25.11
