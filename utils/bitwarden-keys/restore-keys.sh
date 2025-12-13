#!/usr/bin/env bash

set -e

echo "🔐 Restoring SSH and GPG keys from Bitwarden"
echo "============================================="
echo ""

if [ -z "$BW_SESSION" ]; then
    echo "❌ BW_SESSION not set."
    echo "Unlock Bitwarden first:"
    echo "  export BW_SESSION=\$(bw unlock --raw)"
    exit 1
fi

mkdir -p ~/.ssh
chmod 700 ~/.ssh
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

echo "📥 Restoring SSH keys..."
SSH_ITEM=$(bw list items --search "SSH Keys Backup" 2>/dev/null | jq -r '.[0]')

if [ "$SSH_ITEM" != "null" ] && [ -n "$SSH_ITEM" ]; then
    echo "$SSH_ITEM" | jq -r '.notes' | grep -A 100 "BEGIN OPENSSH PRIVATE KEY" | grep -B 100 "END OPENSSH PRIVATE KEY" > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
    
    echo "$SSH_ITEM" | jq -r '.fields[] | select(.name == "public_key") | .value' > ~/.ssh/id_ed25519.pub
    chmod 644 ~/.ssh/id_ed25519.pub
    
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
    
    echo "✅ SSH keys restored"
else
    echo "⚠️  No SSH keys found in Bitwarden"
fi

echo ""
echo "📥 Restoring GPG keys..."
GPG_ITEM=$(bw list items --search "GPG Key" 2>/dev/null | jq -r '.[0]')

if [ "$GPG_ITEM" != "null" ] && [ -n "$GPG_ITEM" ]; then
    GPG_PRIVATE=$(echo "$GPG_ITEM" | jq -r '.notes')
    echo "$GPG_PRIVATE" | gpg --import 2>/dev/null
    
    GPG_KEY_ID=$(echo "$GPG_ITEM" | jq -r '.fields[] | select(.name == "key_id") | .value')
    
    if [ -n "$GPG_KEY_ID" ]; then
        echo "$GPG_KEY_ID:6:" | gpg --import-ownertrust 2>/dev/null || true
        
        git config --global user.signingkey "$GPG_KEY_ID"
        git config --global commit.gpgsign true
        git config --global tag.gpgsign true
        
        echo "✅ GPG keys restored (ID: $GPG_KEY_ID)"
    else
        echo "⚠️  GPG key ID not found"
    fi
else
    echo "⚠️  No GPG keys found in Bitwarden"
fi

echo ""
echo "✅ Restore complete"
