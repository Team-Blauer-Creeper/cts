#!/bin/bash
# ==========================================
# CT Command Tool (mit Auto-Start)
# ==========================================

BIN_DIR="$PREFIX/bin"
PKG_DIR="$HOME/pkg"
mkdir -p "$BIN_DIR"
mkdir -p "$PKG_DIR"

# ct Script
CT_CMD="$BIN_DIR/ct"
cat <<'EOF' > "$CT_CMD"
#!/bin/bash
PKG_DIR="$HOME/pkg"

case "$1" in
    install)
        name="$2"
        if [ -z "$name" ]; then
            echo "Fehler: Kein Projektname angegeben."
            exit 1
        fi
        echo "📦 Lade $name herunter..."
        URL="https://raw.githubusercontent.com/Team-Blauer-Creeper/cts/main/$name.sh"
        mkdir -p "$PKG_DIR/$name"
        wget -q "$URL" -O "$PKG_DIR/$name/$name.sh"
        chmod +x "$PKG_DIR/$name/$name.sh"
        echo "✅ $name installiert!"
        echo "🚀 Starte $name..."
        bash "$PKG_DIR/$name/$name.sh"  # Auto-Start
        ;;
    create)
        name="$2"
        if [ -z "$name" ]; then
            echo "Fehler: Kein Projektname angegeben."
            exit 1
        fi
        mkdir -p "$PKG_DIR/$name"
        echo "📝 Öffne Editor für $name (STRG+X zum Speichern & Beenden)..."
        nano "$PKG_DIR/$name/$name.sh"
        echo "✅ $name gespeichert!"
        ;;
    *)
        echo "Verwendung: ct install <projekt> | ct create <projekt>"
        ;;
esac
EOF

chmod +x "$CT_CMD"
echo "✅ CT-Befehl installiert! Verwende 'ct install <projekt>' oder 'ct create <projekt>'."