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

# Review and adjust home-manager/julien/default.nix if needed

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

**System-wide:**
```nix
# Edit configuration.nix
environment.systemPackages = with pkgs; [
  your-package
];
```

**User-only:**
```nix
# Edit home-manager/julien/default.nix
home.packages = with pkgs; [
  your-package
];
```

Then `rebuild`.

## Structure

```
.
├── flake.nix                  # Entry point
├── configuration.nix          # System config
├── hardware-configuration.nix # Auto-generated
│
├── system/                    # System modules
│   ├── boot.nix
│   ├── audio.nix
│   └── ...
│
├── home-manager/              # Home-manager config
│   ├── julien/               # User config
│   └── programs/             # All programs (zsh, kitty, mango, etc)
│
└── utils/                     # Manual scripts
    └── bitwarden-keys/
```

**Simple and flat.** System in `system/`, user in `home-manager/`.

## Customize

### Programs
Edit files in `home-manager/programs/` then `rebuild`.

### User Packages
Edit `home-manager/julien/default.nix` then `rebuild`.

### System Settings
Edit `configuration.nix` or files in `system/` then `rebuild`.

## Troubleshooting

**Check for errors:**
```bash
nix flake check
```

**Rollback:**
```bash
sudo nixos-rebuild switch --rollback
```

**List generations:**
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
