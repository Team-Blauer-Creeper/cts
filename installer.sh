#!/bin/bash
# ==========================================
# Installer.sh - Team-Blauer-Creeper
# Installiert alle Pakete aus pkg/ und fügt ct delsystem hinzu
# ==========================================

BIN_DIR="$PREFIX/bin"
PKG_DIR="$PWD/pkg"

echo "🛠 Installer startet..."

mkdir -p "$BIN_DIR"

# ------------------------
# Alle Pakete im pkg-Ordner installieren
# ------------------------
for file in "$PKG_DIR"/*.sh; do
    [ -e "$file" ] || continue
    name=$(basename "$file" .sh)
    echo "📦 Installiere $name..."
    cp "$file" "$BIN_DIR/$name"
    chmod +x "$BIN_DIR/$name"
    echo "✅ $name installiert!"
    echo "🚀 Starte $name..."
    bash "$BIN_DIR/$name"
done

# ------------------------
# CT-Befehl installieren
# ------------------------
CT_CMD="$BIN_DIR/ct"
cat <<'EOF' > "$CT_CMD"
#!/bin/bash
case "$1" in
    delsystem)
        echo "⚠️ CT wird gelöscht..."
        rm -f "$PREFIX/bin/ct"
        echo "✅ CT gelöscht!"
        ;;
    *)
        echo "Verwendung: ct delsystem"
        ;;
esac
EOF
chmod +x "$CT_CMD"
echo "✅ CT-Befehl installiert! Verwende 'ct delsystem', um CT zu entfernen."

echo "✅ Alle Pakete installiert und CT eingerichtet!"