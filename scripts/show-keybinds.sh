#!/usr/bin/env bash
# Parse mango keybindings and display them with descriptions from comments

CONFIG_FILE="$HOME/.config/mango/config.conf"

# Parse keybindings and format them
parse_bindings() {
    local prev_comment=""
    
    echo "=== MANGO KEYBINDINGS ==="
    echo ""
    echo "📌 KEYBOARD SHORTCUTS:"
    
    while IFS= read -r line; do
        # Check if line is a comment
        if [[ "$line" =~ ^#[[:space:]](.+)$ ]]; then
            prev_comment="${BASH_REMATCH[1]}"
            continue
        fi
        
        # Check if line is a bind
        if [[ "$line" =~ ^bind= ]]; then
            line="${line#bind=}"
            IFS=',' read -r mods key command params <<< "$line"
            
            if [[ -n "$prev_comment" ]]; then
                printf "  %-30s → %-18s │ %s\n" "$mods+$key" "$command" "$prev_comment"
            else
                printf "  %-30s → %-18s │ %s\n" "$mods+$key" "$command" "$params"
            fi
            prev_comment=""
        else
            # Reset comment if not followed by bind
            if [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
                prev_comment=""
            fi
        fi
    done < "$CONFIG_FILE"
    
    echo ""
    echo "🖱️  MOUSE BINDINGS:"
    prev_comment=""
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^#[[:space:]](.+)$ ]]; then
            prev_comment="${BASH_REMATCH[1]}"
            continue
        fi
        
        if [[ "$line" =~ ^mousebind= ]]; then
            line="${line#mousebind=}"
            IFS=',' read -r mods button command params <<< "$line"
            
            if [[ -n "$prev_comment" ]]; then
                printf "  %-30s → %-18s │ %s\n" "$mods+$button" "$command" "$prev_comment"
            else
                printf "  %-30s → %-18s │ %s\n" "$mods+$button" "$command" "$params"
            fi
            prev_comment=""
        else
            if [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
                prev_comment=""
            fi
        fi
    done < "$CONFIG_FILE"
    
    # Check if there are axis bindings
    if grep -q "^axisbind=" "$CONFIG_FILE"; then
        echo ""
        echo "🔄 SCROLL BINDINGS:"
        prev_comment=""
        
        while IFS= read -r line; do
            if [[ "$line" =~ ^#[[:space:]](.+)$ ]]; then
                prev_comment="${BASH_REMATCH[1]}"
                continue
            fi
            
            if [[ "$line" =~ ^axisbind= ]]; then
                line="${line#axisbind=}"
                IFS=',' read -r mods direction command params <<< "$line"
                
                if [[ -n "$prev_comment" ]]; then
                    printf "  %-30s → %-18s │ %s\n" "$mods+$direction" "$command" "$prev_comment"
                else
                    printf "  %-30s → %-18s │ %s\n" "$mods+$direction" "$command" "$params"
                fi
                prev_comment=""
            else
                if [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
                    prev_comment=""
                fi
            fi
        done < "$CONFIG_FILE"
    fi
    
    # Check if there are gesture bindings
    if grep -q "^gesturebind=" "$CONFIG_FILE"; then
        echo ""
        echo "👆 GESTURE BINDINGS:"
        prev_comment=""
        
        while IFS= read -r line; do
            if [[ "$line" =~ ^#[[:space:]](.+)$ ]]; then
                prev_comment="${BASH_REMATCH[1]}"
                continue
            fi
            
            if [[ "$line" =~ ^gesturebind= ]]; then
                line="${line#gesturebind=}"
                IFS=',' read -r mods direction fingers command params <<< "$line"
                
                if [[ -n "$prev_comment" ]]; then
                    printf "  %-30s → %-18s │ %s\n" "$mods+$direction($fingers fingers)" "$command" "$prev_comment"
                else
                    printf "  %-30s → %-18s │ %s\n" "$mods+$direction($fingers fingers)" "$command" "$params"
                fi
                prev_comment=""
            else
                if [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
                    prev_comment=""
                fi
            fi
        done < "$CONFIG_FILE"
    fi
}

# Display using rofi or fzf
if command -v rofi &> /dev/null; then
    parse_bindings | rofi -dmenu -i -p "Keybindings" -theme-str 'window {width: 70%; height: 80%;}'
elif command -v fzf &> /dev/null; then
    parse_bindings | fzf --header="Use / to search, ESC to quit" --height=100% --no-sort
else
    parse_bindings | less
fi
