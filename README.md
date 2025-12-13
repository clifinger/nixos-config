# NixOS Configuration

My personal NixOS configuration with MangoWC compositor and home-manager.

## 📋 Features

- **Compositor:** MangoWC (Wayland)
- **Shell:** Zsh with Starship prompt
- **Terminal:** Kitty
- **Editor:** Neovim
- **Hardware:** ThinkPad E16 Gen 1 (AMD)

## 🚀 Quick Start

### Fresh Install

1. **Boot NixOS installer** and get network access:
   ```bash
   sudo systemctl start wpa_supplicant
   wpa_cli
   > add_network
   > set_network 0 ssid "YOUR_WIFI"
   > set_network 0 psk "YOUR_PASSWORD"
   > enable_network 0
   > quit
   ```

2. **Partition and format** (adjust as needed):
   ```bash
   # Example for UEFI systems
   parted /dev/nvme0n1 -- mklabel gpt
   parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
   parted /dev/nvme0n1 -- set 1 esp on
   parted /dev/nvme0n1 -- mkpart primary 512MiB 100%
   
   mkfs.fat -F 32 -n boot /dev/nvme0n1p1
   mkfs.ext4 -L nixos /dev/nvme0n1p2
   
   mount /dev/disk/by-label/nixos /mnt
   mkdir -p /mnt/boot
   mount /dev/disk/by-label/boot /mnt/boot
   ```

3. **Clone this repo and install**:
   ```bash
   cd /mnt
   nix-shell -p git
   git clone https://github.com/YOUR_USERNAME/nixos-config etc/nixos
   cd /etc/nixos
   
   # Generate hardware config
   nixos-generate-config --show-hardware-config > hardware-configuration.nix
   
   # Install
   nixos-install --flake .#nixos
   
   # Set password
   nixos-enter
   passwd julien
   exit
   
   reboot
   ```

### Rebuild System

After making changes:
```bash
sudo nixos-rebuild switch --flake .#nixos
```

Or use the alias:
```bash
rebuild
```

### Update All Inputs

```bash
nix flake update
sudo nixos-rebuild switch --flake .#nixos
```

## 📁 Structure

```
.
├── flake.nix                  # Flake entry point
├── flake.lock                 # Locked dependencies
├── hardware-configuration.nix # Auto-generated hardware config
│
├── hosts/nixos/              # System configuration
│   └── default.nix          # Main system config
│
├── system/                   # System modules
│   ├── boot.nix
│   ├── networking.nix
│   ├── audio.nix
│   └── ...
│
├── users/julien/             # User-specific home-manager config
│   └── default.nix
│
├── home/                     # Reusable home-manager modules
│   ├── programs/            # Program configs (zsh, kitty, nvim, starship)
│   ├── wm/                  # Window manager configs (mango, dms)
│   └── services/
│
├── desktop/                  # Desktop environment settings
└── scripts/                  # Helper scripts
```

### Why This Structure?

- **hosts/nixos/** - Easy to add more machines later (laptop, desktop, server)
- **system/** - System configs split by topic for clarity
- **home/** - Reusable modules you can share across users/machines
- **users/julien/** - Personal config that imports from home/

## 🔧 Common Tasks

### Add a Package

System-wide:
```nix
# hosts/nixos/default.nix
environment.systemPackages = with pkgs; [
  your-package
];
```

User-specific:
```nix
# users/julien/default.nix
home.packages = with pkgs; [
  your-package
];
```

### Modify Zsh Config

Edit `home/programs/zsh.nix` then rebuild.

### Change Starship Prompt

Edit `home/programs/starship.nix` then rebuild.

## 📝 Notes

- **No sudo password:** Wheel group doesn't need password
- **Auto-login:** Getty auto-logs in as julien
- **Flakes enabled:** Using experimental nix-command and flakes features
- **Docker:** Disabled by default, use `don`/`doff` to start/stop

## 🆘 Troubleshooting

### Rebuild fails
```bash
nix flake check  # Check for errors
```

### Rollback to previous generation
```bash
sudo nixos-rebuild switch --rollback
```

### List generations
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

---

**System Version:** NixOS 26.05 (Unstable)  
**State Version:** 25.11
