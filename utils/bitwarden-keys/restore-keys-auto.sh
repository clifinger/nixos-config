#!/usr/bin/env bash

set -e

EMAIL="${1:-}"

echo "🔐 Configuring SSH and GPG keys from Bitwarden"
echo "==============================================="
echo ""

if ! command -v bw &> /dev/null; then
    echo "❌ Bitwarden CLI not installed."
    echo "Add 'bitwarden-cli' to environment.systemPackages"
    echo "Then run: sudo nixos-rebuild switch"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "❌ jq not installed."
    echo "Add 'jq' to environment.systemPackages"
    echo "Then run: sudo nixos-rebuild switch"
    exit 1
fi

BW_STATUS=$(bw status | jq -r .status 2>/dev/null || echo "unauthenticated")

if [ "$BW_STATUS" = "unauthenticated" ]; then
    echo "🔑 Bitwarden login required"
    echo ""
    
    if [ -z "$EMAIL" ]; then
        read -p "Bitwarden email: " EMAIL
    fi
    
    echo "Logging in..."
    if ! bw login "$EMAIL"; then
        echo "❌ Login failed"
        exit 1
    fi
    
    BW_STATUS=$(bw status | jq -r .status)
fi

if [ "$BW_STATUS" != "unlocked" ]; then
    echo ""
    echo "🔓 Unlocking vault..."
    BW_SESSION=$(bw unlock --raw)
    
    if [ -z "$BW_SESSION" ]; then
        echo "❌ Unlock failed"
        exit 1
    fi
    
    export BW_SESSION
    echo "✓ Vault unlocked"
fi

echo ""
echo "☁️  Syncing..."
bw sync > /dev/null 2>&1

echo ""
SSH_EXISTS=$(bw list items --search "SSH Keys Backup" 2>/dev/null | jq -r 'length')
GPG_EXISTS=$(bw list items --search "GPG Key" 2>/dev/null | jq -r 'length')

if [ "$SSH_EXISTS" = "0" ] && [ "$GPG_EXISTS" = "0" ]; then
    echo "⚠️  No keys found in Bitwarden."
    echo ""
    echo "Options:"
    echo "  1. First install: generate new keys"
    echo "  2. Have keys on another machine: backup them first:"
    echo "     cd ~/scripts/bitwarden-keys && ./backup-keys.sh"
    echo ""
    read -p "Generate new keys now? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        read -p "Email for SSH key (e.g. user@example.com): " SSH_EMAIL
        
        if [ -n "$SSH_EMAIL" ]; then
            echo "🔑 Generating SSH key..."
            mkdir -p ~/.ssh
            ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f ~/.ssh/id_ed25519 -N ""
            eval "$(ssh-agent -s)" > /dev/null
            ssh-add ~/.ssh/id_ed25519
            
            echo ""
            echo "✅ SSH key generated: ~/.ssh/id_ed25519.pub"
            echo ""
            echo "📋 Add this public key to GitHub:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            cat ~/.ssh/id_ed25519.pub
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "🌐 Open: https://github.com/settings/ssh/new"
            read -p "Press Enter after adding key..."
        fi
        
        echo ""
        read -p "Generate GPG key for signing commits? (y/N) " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🔑 Generating GPG key..."
            echo ""
            echo "Follow instructions:"
            echo "  - Type: (1) RSA and RSA"
            echo "  - Size: 4096 bits"
            echo "  - Expiration: 0 (no expiry) or as preferred"
            echo ""
            
            gpg --full-generate-key
            
            GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep ^sec | tail -1 | sed 's/.*\/\([^ ]*\).*/\1/')
            
            if [ -n "$GPG_KEY_ID" ]; then
                echo ""
                echo "✅ GPG key generated: $GPG_KEY_ID"
                
                git config --global user.signingkey "$GPG_KEY_ID"
                git config --global commit.gpgsign true
                git config --global tag.gpgsign true
                
                echo ""
                echo "📋 Add this public key to GitHub:"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                gpg --armor --export "$GPG_KEY_ID"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo ""
                echo "🌐 Open: https://github.com/settings/gpg/new"
                read -p "Press Enter after adding key..."
            fi
        fi
        
        echo ""
        read -p "Backup new keys to Bitwarden? (Y/n) " -n 1 -r
        echo
        
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            echo "💾 Backing up to Bitwarden..."
            cd ~/scripts/bitwarden-keys
            export BW_SESSION
            ./backup-keys.sh
        fi
    fi
else
    echo "📥 Keys found in Bitwarden:"
    [ "$SSH_EXISTS" != "0" ] && echo "  ✓ SSH keys"
    [ "$GPG_EXISTS" != "0" ] && echo "  ✓ GPG keys"
    echo ""
    read -p "Restore these keys? (Y/n) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        cd ~/scripts/bitwarden-keys
        export BW_SESSION
        ./restore-keys.sh
    fi
fi

echo ""
echo "🔒 Locking Bitwarden vault..."
bw lock > /dev/null 2>&1

echo ""
echo "✅ Keys configuration complete"
echo ""
echo "📚 Useful commands:"
echo "  • Backup keys:   ~/scripts/bitwarden-keys/backup-keys.sh"
echo "  • Restore keys:  ~/scripts/bitwarden-keys/restore-keys.sh"
echo "  • View SSH key:  cat ~/.ssh/id_ed25519.pub"
echo "  • View GPG keys: gpg --list-secret-keys"
