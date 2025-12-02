#!/usr/bin/env bash
# Script automatique pour restaurer les clés SSH et GPG depuis Bitwarden
# Utilisé lors de l'installation initiale des dotfiles
# Usage: ./restore-keys-auto.sh [email]

set -e

EMAIL="${1:-}"

echo "🔐 Configuration des clés SSH et GPG depuis Bitwarden"
echo "======================================================"
echo ""

# Vérifier que bw est installé
if ! command -v bw &> /dev/null; then
    echo "❌ Bitwarden CLI n'est pas installé."
    echo "Ajoutez 'bitwarden-cli' à votre configuration.nix dans environment.systemPackages"
    echo "Puis exécutez: sudo nixos-rebuild switch"
    exit 1
fi

# Vérifier jq
if ! command -v jq &> /dev/null; then
    echo "❌ jq n'est pas installé."
    echo "Ajoutez 'jq' à votre configuration.nix dans environment.systemPackages"
    echo "Puis exécutez: sudo nixos-rebuild switch"
    exit 1
fi

# Statut de connexion
BW_STATUS=$(bw status | jq -r .status 2>/dev/null || echo "unauthenticated")

if [ "$BW_STATUS" = "unauthenticated" ]; then
    echo "🔑 Connexion à Bitwarden requise"
    echo ""
    
    if [ -z "$EMAIL" ]; then
        read -p "Email Bitwarden: " EMAIL
    fi
    
    echo "Connexion en cours..."
    if ! bw login "$EMAIL"; then
        echo "❌ Échec de la connexion"
        exit 1
    fi
    
    BW_STATUS=$(bw status | jq -r .status)
fi

# Déverrouillage
if [ "$BW_STATUS" != "unlocked" ]; then
    echo ""
    echo "🔓 Déverrouillage du coffre-fort..."
    BW_SESSION=$(bw unlock --raw)
    
    if [ -z "$BW_SESSION" ]; then
        echo "❌ Échec du déverrouillage"
        exit 1
    fi
    
    export BW_SESSION
    echo "✓ Coffre-fort déverrouillé"
fi

# Synchroniser
echo ""
echo "☁️  Synchronisation..."
bw sync > /dev/null 2>&1

# Vérifier si les clés existent dans Bitwarden
echo ""
SSH_EXISTS=$(bw list items --search "SSH Keys Backup" 2>/dev/null | jq -r 'length')
GPG_EXISTS=$(bw list items --search "GPG Key" 2>/dev/null | jq -r 'length')

if [ "$SSH_EXISTS" = "0" ] && [ "$GPG_EXISTS" = "0" ]; then
    echo "⚠️  Aucune clé trouvée dans Bitwarden."
    echo ""
    echo "Options:"
    echo "  1. Si c'est votre première installation, générez de nouvelles clés"
    echo "  2. Si vous avez des clés sur une autre machine, sauvegardez-les d'abord:"
    echo "     cd ~/scripts/bitwarden-keys && ./backup-keys.sh"
    echo ""
    read -p "Voulez-vous générer de nouvelles clés maintenant? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Générer clé SSH
        echo ""
        read -p "Email pour la clé SSH (ex: user@example.com): " SSH_EMAIL
        
        if [ -n "$SSH_EMAIL" ]; then
            echo "🔑 Génération de la clé SSH..."
            mkdir -p ~/.ssh
            ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f ~/.ssh/id_ed25519 -N ""
            eval "$(ssh-agent -s)" > /dev/null
            ssh-add ~/.ssh/id_ed25519
            
            echo ""
            echo "✅ Clé SSH générée: ~/.ssh/id_ed25519.pub"
            echo ""
            echo "📋 Ajoutez cette clé publique à GitHub:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            cat ~/.ssh/id_ed25519.pub
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "🌐 Ouvrez: https://github.com/settings/ssh/new"
            read -p "Appuyez sur Enter une fois la clé ajoutée..."
        fi
        
        # Générer clé GPG
        echo ""
        read -p "Voulez-vous générer une clé GPG pour signer vos commits? (y/N) " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🔑 Génération de la clé GPG..."
            echo ""
            echo "Suivez les instructions:"
            echo "  - Type: (1) RSA et RSA"
            echo "  - Taille: 4096 bits"
            echo "  - Expiration: 0 (ne pas expirer) ou selon préférence"
            echo ""
            
            gpg --full-generate-key
            
            # Récupérer l'ID de la clé
            GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep ^sec | tail -1 | sed 's/.*\/\([^ ]*\).*/\1/')
            
            if [ -n "$GPG_KEY_ID" ]; then
                echo ""
                echo "✅ Clé GPG générée: $GPG_KEY_ID"
                
                # Configurer Git
                git config --global user.signingkey "$GPG_KEY_ID"
                git config --global commit.gpgsign true
                git config --global tag.gpgsign true
                
                echo ""
                echo "📋 Ajoutez cette clé publique à GitHub:"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                gpg --armor --export "$GPG_KEY_ID"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo ""
                echo "🌐 Ouvrez: https://github.com/settings/gpg/new"
                read -p "Appuyez sur Enter une fois la clé ajoutée..."
            fi
        fi
        
        # Sauvegarder dans Bitwarden
        echo ""
        read -p "Voulez-vous sauvegarder ces nouvelles clés dans Bitwarden? (Y/n) " -n 1 -r
        echo
        
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            echo "💾 Sauvegarde dans Bitwarden..."
            cd ~/scripts/bitwarden-keys
            export BW_SESSION
            ./backup-keys.sh
        fi
    fi
else
    echo "📥 Clés trouvées dans Bitwarden:"
    [ "$SSH_EXISTS" != "0" ] && echo "  ✓ Clés SSH"
    [ "$GPG_EXISTS" != "0" ] && echo "  ✓ Clés GPG"
    echo ""
    read -p "Restaurer ces clés? (Y/n) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        # Exécuter le script de restauration
        cd ~/scripts/bitwarden-keys
        export BW_SESSION
        ./restore-keys.sh
    fi
fi

# Verrouiller Bitwarden par sécurité
echo ""
echo "🔒 Verrouillage du coffre-fort Bitwarden..."
bw lock > /dev/null 2>&1

echo ""
echo "✅ Configuration des clés terminée !"
echo ""
echo "📚 Commandes utiles:"
echo "  • Sauvegarder les clés:  ~/scripts/bitwarden-keys/backup-keys.sh"
echo "  • Restaurer les clés:    ~/scripts/bitwarden-keys/restore-keys.sh"
echo "  • Voir les clés SSH:     cat ~/.ssh/id_ed25519.pub"
echo "  • Voir les clés GPG:     gpg --list-secret-keys"
