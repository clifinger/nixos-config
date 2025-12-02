#!/usr/bin/env bash
# Script pour sauvegarder les clés SSH et GPG dans Bitwarden
# Usage: ./backup-keys.sh

set -e

echo "💾 Sauvegarde des clés SSH et GPG dans Bitwarden"
echo "================================================="
echo ""

# Vérifier que BW_SESSION est défini
if [ -z "$BW_SESSION" ]; then
    echo "❌ BW_SESSION n'est pas défini."
    echo "Déverrouillez d'abord Bitwarden:"
    echo "  export BW_SESSION=\$(bw unlock --raw)"
    exit 1
fi

# Sauvegarder les clés SSH
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "📤 Sauvegarde des clés SSH..."
    
    # Vérifier si l'item existe déjà
    EXISTING_SSH=$(bw list items --search "SSH Keys Backup" 2>/dev/null | jq -r '.[0].id // empty')
    
    if [ -n "$EXISTING_SSH" ]; then
        echo "⚠️  Une sauvegarde SSH existe déjà (ID: $EXISTING_SSH)"
        read -p "Voulez-vous la remplacer? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bw delete item "$EXISTING_SSH" > /dev/null
        else
            echo "⏭️  Sauvegarde SSH ignorée"
            SKIP_SSH=1
        fi
    fi
    
    if [ -z "$SKIP_SSH" ]; then
        # Créer l'item
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
        
        echo "✅ Clés SSH sauvegardées"
    fi
else
    echo "⚠️  Aucune clé SSH trouvée (~/.ssh/id_ed25519)"
fi

# Sauvegarder les clés GPG
echo ""
GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep ^sec | tail -1 | sed 's/.*\/\([^ ]*\).*/\1/' || true)

if [ -n "$GPG_KEY_ID" ]; then
    echo "📤 Sauvegarde de la clé GPG ($GPG_KEY_ID)..."
    
    # Vérifier si l'item existe déjà
    EXISTING_GPG=$(bw list items --search "GPG Key" 2>/dev/null | jq -r '.[0].id // empty')
    
    if [ -n "$EXISTING_GPG" ]; then
        echo "⚠️  Une sauvegarde GPG existe déjà (ID: $EXISTING_GPG)"
        read -p "Voulez-vous la remplacer? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bw delete item "$EXISTING_GPG" > /dev/null
        else
            echo "⏭️  Sauvegarde GPG ignorée"
            SKIP_GPG=1
        fi
    fi
    
    if [ -z "$SKIP_GPG" ]; then
        # Exporter la clé privée
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
        
        echo "✅ Clé GPG sauvegardée"
    fi
else
    echo "⚠️  Aucune clé GPG trouvée"
fi

echo ""
echo "✅ Sauvegarde terminée !"
echo ""
echo "🔄 Synchronisation avec le serveur..."
bw sync > /dev/null 2>&1
echo "✅ Synchronisé"
