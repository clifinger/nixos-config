#!/usr/bin/env bash
# Script pour restaurer les clés SSH et GPG depuis Bitwarden
# Usage: ./restore-keys.sh

set -e

echo "🔐 Restauration des clés SSH et GPG depuis Bitwarden"
echo "====================================================="
echo ""

# Vérifier que BW_SESSION est défini
if [ -z "$BW_SESSION" ]; then
    echo "❌ BW_SESSION n'est pas défini."
    echo "Déverrouillez d'abord Bitwarden:"
    echo "  export BW_SESSION=\$(bw unlock --raw)"
    exit 1
fi

# Créer les répertoires nécessaires
mkdir -p ~/.ssh
chmod 700 ~/.ssh
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# Restaurer les clés SSH
echo "📥 Restauration des clés SSH..."
SSH_ITEM=$(bw list items --search "SSH Keys Backup" 2>/dev/null | jq -r '.[0]')

if [ "$SSH_ITEM" != "null" ] && [ -n "$SSH_ITEM" ]; then
    # Extraire la clé privée
    echo "$SSH_ITEM" | jq -r '.notes' | grep -A 100 "BEGIN OPENSSH PRIVATE KEY" | grep -B 100 "END OPENSSH PRIVATE KEY" > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
    
    # Extraire la clé publique
    echo "$SSH_ITEM" | jq -r '.fields[] | select(.name == "public_key") | .value' > ~/.ssh/id_ed25519.pub
    chmod 644 ~/.ssh/id_ed25519.pub
    
    # Ajouter au ssh-agent
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
    
    echo "✅ Clés SSH restaurées"
else
    echo "⚠️  Aucune clé SSH trouvée dans Bitwarden"
fi

# Restaurer les clés GPG
echo ""
echo "📥 Restauration des clés GPG..."
GPG_ITEM=$(bw list items --search "GPG Key" 2>/dev/null | jq -r '.[0]')

if [ "$GPG_ITEM" != "null" ] && [ -n "$GPG_ITEM" ]; then
    # Extraire et importer la clé privée
    GPG_PRIVATE=$(echo "$GPG_ITEM" | jq -r '.notes')
    echo "$GPG_PRIVATE" | gpg --import 2>/dev/null
    
    # Récupérer l'ID de la clé
    GPG_KEY_ID=$(echo "$GPG_ITEM" | jq -r '.fields[] | select(.name == "key_id") | .value')
    
    if [ -n "$GPG_KEY_ID" ]; then
        # Configurer la confiance maximale
        echo "$GPG_KEY_ID:6:" | gpg --import-ownertrust 2>/dev/null || true
        
        # Configurer Git
        git config --global user.signingkey "$GPG_KEY_ID"
        git config --global commit.gpgsign true
        git config --global tag.gpgsign true
        
        echo "✅ Clés GPG restaurées (ID: $GPG_KEY_ID)"
    else
        echo "⚠️  ID de clé GPG non trouvé"
    fi
else
    echo "⚠️  Aucune clé GPG trouvée dans Bitwarden"
fi

echo ""
echo "✅ Restauration terminée !"
