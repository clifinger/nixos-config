#!/usr/bin/env bash
# Quick activation script - run this outside of OpenCode

set -e

echo "=== Activating NixOS Configuration ==="
echo ""

cd /home/julien/nixos-config

echo "1. Rebuilding NixOS system..."
sudo nixos-rebuild switch --flake .#nixos

echo ""
echo "2. Activating home-manager configuration..."
systemctl --user restart home-manager-julien.service

echo ""
echo "3. Installing Anytype from Flathub..."

# Check if flatpak is available
if ! command -v flatpak &> /dev/null; then
    echo "   ERROR: Flatpak not available. Please reboot and try again."
    exit 1
fi

# Add flathub if not present
if ! flatpak remote-list --user | grep -q flathub; then
    echo "   Adding Flathub repository..."
    flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install Anytype
if ! flatpak list --user | grep -q io.anytype.anytype; then
    echo "   Installing Anytype..."
    flatpak install --user -y flathub io.anytype.anytype
else
    echo "   ✓ Anytype already installed"
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Anytype is now available:"
echo "  - Press ALT+Space and search for 'Anytype'"
echo "  - Or run: anytype"
echo ""
echo "Your data will be persisted in: ~/.var/app/io.anytype.anytype/"
