# NixOS Configuration

A modular, production-ready NixOS configuration featuring MangoWC (Wayland compositor) and DankMaterialShell.

## Features

- **Modular Architecture**: Clean separation between system, desktop, and user configurations
- **Wayland-First**: MangoWC compositor with DankMaterialShell integration
- **Declarative**: Everything managed through Nix flakes and Home Manager
- **ThinkPad Optimized**: Custom configurations for ThinkPad hardware
- **Modern CLI Tools**: eza, bat, fzf, zoxide, lazygit, lazydocker
- **Developer-Friendly**: Neovim, Git with GPG signing, Docker support

## Structure

```
nixos-config/
├── flake.nix              # Main flake configuration
├── hosts/
│   └── nixos/             # Host-specific configuration
│       ├── default.nix
│       └── hardware-configuration.nix
├── system/                # System-level modules
│   ├── boot.nix
│   ├── networking.nix
│   ├── audio.nix
│   ├── bluetooth.nix
│   ├── security.nix
│   ├── services.nix
│   ├── thinkpad.nix
│   └── virtualization.nix
├── desktop/               # Desktop environment
│   └── wayland.nix
├── home/                  # Home Manager modules
│   ├── programs/          # User programs
│   │   ├── kitty.nix
│   │   ├── zsh.nix
│   │   ├── neovim.nix
│   │   └── maple-font.nix
│   └── wm/                # Window manager
│       ├── mango.nix
│       └── dms.nix
├── users/
│   └── julien/            # User-specific configuration
│       └── default.nix
└── scripts/               # Utility scripts
    └── bitwarden-keys/
```

## Installation

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/clifinger/nixos-config.git ~/nixos-config
cd ~/nixos-config

# Apply configuration
sudo nixos-rebuild switch --flake .#nixos
```

### Restore SSH/GPG Keys (Optional)

```bash
# Login to Bitwarden
bw login

# Restore keys
~/nixos-config/scripts/bitwarden-keys/restore-keys-auto.sh
```

## System Configuration

### Boot & Kernel
- Systemd-boot bootloader
- Xanmod kernel for performance

### Audio
- PipeWire with ALSA and PulseAudio compatibility

### Security
- Passwordless sudo for wheel group
- GPG agent with SSH support
- Polkit enabled

### ThinkPad
- Fan control enabled
- All hotkeys functional
- MicMute LED control

## Window Manager (MangoWC)

### Layouts
- Scroller (default)
- Tile
- Monocle

### Multi-Monitor Support
- eDP-1: 2560x1600 @ 1.3 scale
- DP-4: 2560x1440 @ 1.0 scale
- DP-6: 3840x2160 @ 1.5 scale

### Key Bindings

#### System
- `Super + R`: Reload config
- `Super + Shift + R`: Restart DMS
- `Super + L`: Lock screen

#### Applications
- `Super + Enter`: Terminal (Kitty)
- `Super + B`: Browser (Chromium)
- `Super + E`: File manager (Nautilus)
- `Alt + Space`: Launcher (DMS)

#### Window Management
- `Super + Q`: Close window
- `Super + F`: Toggle floating
- `Super + M`: Monocle layout
- `Super + O`: Overview mode

#### Navigation
- `Super + Arrows`: Focus direction
- `Super + Shift + Arrows`: Move window
- `Super + Tab`: Next window

#### Screenshots
- `Ctrl + Print`: Full screen
- `Super + Print`: Area selection
- `Super + Shift + Print`: Area to clipboard

## Development Tools

### Terminal
- **Kitty**: GPU-accelerated with Maple Mono Nerd Font
- **Zsh**: Powerlevel10k theme with Zinit plugin manager

### Editors
- **Neovim**: Full IDE setup from [clifinger/nvim-for-dev](https://github.com/clifinger/nvim-for-dev)

### Version Control
- **Git**: Configured with GPG signing
- **Lazygit**: Terminal UI for Git

### Containers
- **Docker**: Manual start (disabled on boot)
- **Lazydocker**: Terminal UI for Docker

## Updating

```bash
cd ~/nixos-config

# Update flake inputs
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#nixos
```

## Customization

### Add System Packages
Edit `hosts/nixos/default.nix`:
```nix
environment.systemPackages = with pkgs; [
  # Add your packages here
];
```

### Add User Packages
Edit `users/julien/default.nix`:
```nix
home.packages = with pkgs; [
  # Add your packages here
];
```

### Modify MangoWC Settings
Edit `home/wm/mango.nix`

### Adjust Keybindings
Edit the `settings` section in `home/wm/mango.nix`

## Troubleshooting

### Check Configuration
```bash
nix flake check
```

### Test Without Applying
```bash
sudo nixos-rebuild build --flake .#nixos
```

### View Logs
```bash
journalctl -xeu mango
journalctl -xeu home-manager-julien
```

## Repository

- **GitHub**: https://github.com/clifinger/nixos-config
- **Author**: Julien Lenne
- **License**: MIT

## References

- [NixOS](https://nixos.org/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [MangoWC](https://github.com/DreamMaoMao/mangowc)
- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
