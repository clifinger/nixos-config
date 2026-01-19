#!/usr/bin/env bash
# Activation script to apply the new OpenCode configuration
# Run this in a NORMAL TERMINAL (not in OpenCode)

set -e

echo "=== Applying OpenCode sudo fix ==="
echo ""
echo "This will:"
echo "  1. Rebuild NixOS with Flatpak support"
echo "  2. Update OpenCode wrapper to allow sudo"
echo "  3. Install Anytype via Flatpak"
echo ""

cd /home/julien/nixos-config

echo "Step 1: Rebuilding NixOS configuration..."
sudo nixos-rebuild switch --flake .#nixos

echo ""
echo "Step 2: Restarting home-manager service..."
systemctl --user restart home-manager-julien.service

echo ""
echo "Step 3: Verifying OpenCode wrapper..."
cat ~/.local/bin/opencode

echo ""
echo "Step 4: Installing Anytype..."

if ! command -v flatpak &> /dev/null; then
    echo "WARNING: Flatpak not found. You may need to reboot."
    echo "After reboot, run: flatpak install --user flathub io.anytype.anytype"
else
    # Add Flathub
    if ! flatpak remote-list --user | grep -q flathub; then
        flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    
    # Install Anytype
    if ! flatpak list --user | grep -q io.anytype.anytype; then
        flatpak install --user -y flathub io.anytype.anytype
        echo "✓ Anytype installed"
    else
        echo "✓ Anytype already installed"
    fi
fi

echo ""
echo "=== Done! ==="
echo ""
echo "IMPORTANT: You need to RESTART OpenCode for the changes to take effect!"
echo ""
echo "After restarting OpenCode, you should be able to use sudo."
echo "Test with: sudo echo 'sudo works!'"
