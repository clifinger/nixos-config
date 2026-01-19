# Anytype Setup Changes

## Summary
Switched from AppImage to Flatpak installation to fix the persistent recovery phrase issue.

## Changes Made

### 1. System Configuration (`system/flatpak.nix`)
- Enabled Flatpak support system-wide
- Configured automatic Flathub repository setup
- Added XDG desktop portals for proper integration

### 2. Home Manager Configuration (`home-manager/julien/default.nix`)
- Removed broken `anytype` package from nixpkgs (GCC 15.2.0 compilation error)
- Added `anytype` wrapper script that launches the Flatpak version
- Created desktop entry for application launcher integration
  - Searchable via ALT+Space in mangowc launcher
  - Includes proper icon, categories, and MIME types

### 3. Startup Script (`home-manager/programs/mango.nix`)
- Updated to launch Anytype via Flatpak on startup

### 4. Installation Script (`~/.local/bin/install-anytype-flatpak.sh`)
- Automated installation script in English
- Rebuilds NixOS configuration
- Installs Anytype from Flathub
- Offers to clean up old AppImage

## Why Flatpak?

1. **Proper data persistence**: Flatpak stores data in `~/.var/app/io.anytype.anytype/` with correct permissions
2. **Better sandbox**: Mature sandboxing system compared to AppImage
3. **Automatic updates**: Can update independently of NixOS
4. **No compilation issues**: Pre-built binaries from Flathub

## Installation

Run the installation script:
```bash
~/.local/bin/install-anytype-flatpak.sh
```

Or rebuild manually:
```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#nixos
flatpak install --user flathub io.anytype.anytype
```

## Usage

After installation, you can launch Anytype in several ways:

1. **Application Launcher**: Press `ALT+Space` and type "Anytype"
2. **Command line**: `anytype` (wrapper script)
3. **Direct Flatpak**: `flatpak run io.anytype.anytype`

## Data Location

- **Flatpak data**: `~/.var/app/io.anytype.anytype/`
- **Old AppImage data**: `~/.config/anytype/` (can be migrated or removed)

## Important Notes

- On first launch, you'll need to enter your recovery phrase one last time
- After that, your keystore will be properly persisted
- The old AppImage installation can be safely removed after confirming Flatpak works
