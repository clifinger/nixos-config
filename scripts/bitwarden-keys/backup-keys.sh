#!/usr/bin/env bash

set -e

echo "💾 Backing up SSH and GPG keys to Bitwarden"
echo "============================================"
echo ""

if [ -z "$BW_SESSION" ]; then
    echo "❌ BW_SESSION not set."
    echo "Unlock Bitwarden first:"
    echo "  export BW_SESSION=\$(bw unlock --raw)"
    exit 1
fi

if [ -f ~/.ssh/id_ed25519 ]; then
    echo "📤 Backing up SSH keys..."
    
    EXISTING_SSH=$(bw list items --search "SSH Keys Backup" 2>/dev/null | jq -r '.[0].id // empty')
    
    if [ -n "$EXISTING_SSH" ]; then
        echo "⚠️  SSH backup already exists (ID: $EXISTING_SSH)"
        read -p "Replace? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bw delete item "$EXISTING_SSH" > /dev/null
        else
            echo "⏭️  SSH backup skipped"
            SKIP_SSH=1
        fi
    fi
    
    if [ -z "$SKIP_SSH" ]; then
        SSH_PRIVATE=$(cat ~/.ssh/id_ed25519)
        SSH_PUBLIC=$(cat ~/.ssh/id_ed25519.pub)
        
        cat > /tmp/bw-ssh.json <<EOF
{
  "organizationId": null,
  "folderId": null,
  "type": 2,
  "name": "SSH Keys Backup",
  "notes": "$SSH_PRIVATE",
  "favorite": false,
  "fields": [
    {
      "name": "public_key",
      "value": "$SSH_PUBLIC",
      "type": 0
    }
  ],
  "secureNote": {
    "type": 0
  }
}
EOF
        
        bw encode < /tmp/bw-ssh.json | bw create item > /dev/null
        rm /tmp/bw-ssh.json
        
        echo "✅ SSH keys backed up"
    fi
else
    echo "⚠️  No SSH key found (~/.ssh/id_ed25519)"
fi

echo ""
GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep ^sec | tail -1 | sed 's/.*\/\([^ ]*\).*/\1/' || true)

if [ -n "$GPG_KEY_ID" ]; then
    echo "📤 Backing up GPG key ($GPG_KEY_ID)..."
    
    EXISTING_GPG=$(bw list items --search "GPG Key" 2>/dev/null | jq -r '.[0].id // empty')
    
    if [ -n "$EXISTING_GPG" ]; then
        echo "⚠️  GPG backup already exists (ID: $EXISTING_GPG)"
        read -p "Replace? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bw delete item "$EXISTING_GPG" > /dev/null
        else
            echo "⏭️  GPG backup skipped"
            SKIP_GPG=1
        fi
    fi
    
    if [ -z "$SKIP_GPG" ]; then
        GPG_PRIVATE=$(gpg --armor --export-secret-keys "$GPG_KEY_ID" 2>/dev/null | sed 's/$/\\n/' | tr -d '\n')
        GPG_PUBLIC=$(gpg --armor --export "$GPG_KEY_ID" 2>/dev/null)
        
        cat > /tmp/bw-gpg.json <<EOF
{
  "organizationId": null,
  "folderId": null,
  "type": 2,
  "name": "GPG Key",
  "notes": "$(echo "$GPG_PRIVATE" | sed 's/\\n/\n/g')",
  "favorite": false,
  "fields": [
    {
      "name": "key_id",
      "value": "$GPG_KEY_ID",
      "type": 0
    },
    {
      "name": "public_key",
      "value": "$GPG_PUBLIC",
      "type": 0
    }
  ],
  "secureNote": {
    "type": 0
  }
}
EOF
        
        bw encode < /tmp/bw-gpg.json | bw create item > /dev/null
        rm /tmp/bw-gpg.json
        
        echo "✅ GPG key backed up"
    fi
else
    echo "⚠️  No GPG key found"
fi

echo ""
echo "✅ Backup complete"
echo ""
echo "🔄 Syncing with server..."
bw sync > /dev/null 2>&1
echo "✅ Synced"
