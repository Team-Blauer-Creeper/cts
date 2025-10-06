#!/bin/bash
# ==========================================
# Team Blue Creeper - ct Installer
# ==========================================

PKG_DIR="$HOME/pkg"
mkdir -p "$PKG_DIR"

BIN_DIR="$PREFIX/bin"
mkdir -p "$BIN_DIR"

# ----------------------
# ct Befehl
# ----------------------
cat <<'EOF' > "$BIN_DIR/ct"
#!/bin/bash

PKG_DIR="$HOME/pkg"
mkdir -p "$PKG_DIR"

usage() {
    echo "Verwendung:"
    echo "  ct install <projekt>   - Projekt installieren"
    echo "  ct create <projekt>    - Neues Projekt erstellen"
    echo "  ct update <projekt>    - Projekt aktualisieren (Git)"
}

install_project() {
    name="$1"
    if [ -z "$name" ]; then
        usage
        exit 1
    fi
    DEST="$PKG_DIR/$name"
    if [ -d "$DEST" ]; then
        echo "📦 $name existiert bereits!"
        return
    fi
    echo "📥 Installiere $name ..."
    git clone --depth=1 "https://github.com/team-blue-creeper/$name" "$DEST"
    if [ $? -eq 0 ]; then
        echo "✅ $name installiert in $DEST"
        # Prüfe Startdatei
        if [ -f "$DEST/main.py" ]; then
            echo "🚀 Starte main.py..."
            python3 "$DEST/main.py"
        elif [ -f "$DEST/$name.sh" ]; then
            echo "🚀 Starte $name.sh..."
            bash "$DEST/$name.sh"
        else
            echo "ℹ️  Keine Startdatei gefunden."
        fi
    else
        echo "❌ Fehler beim Klonen!"
    fi
}

create_project() {
    name="$1"
    if [ -z "$name" ]; then
        usage
        exit 1
    fi
    DEST="$PKG_DIR/$name"
    mkdir -p "$DEST"
    echo "📝 Neues Projekt $name erstellen..."
    FILE="$DEST/main.py"
    if [ ! -f "$FILE" ]; then
        echo "#!/usr/bin/env python3" > "$FILE"
        echo "print('Hello $name')" >> "$FILE"
    fi
    nano "$FILE"
    chmod +x "$FILE"
    echo "✅ Projekt $name erstellt in $DEST"
}

update_project() {
    name="$1"
    if [ -z "$name" ]; then
        usage
        exit 1
    fi
    DEST="$PKG_DIR/$name"
    if [ ! -d "$DEST" ]; then
        echo "❌ Projekt nicht gefunden!"
        return
    fi
    cd "$DEST"
    git pull
    echo "✅ $name aktualisiert!"
}

case "$1" in
    install) install_project "$2" ;;
    create)  create_project "$2" ;;
    update)  update_project "$2" ;;
    *) usage ;;
esac
EOF

chmod +x "$BIN_DIR/ct"

echo "✅ ct installiert! Du kannst jetzt 'ct install <projekt>' oder 'ct create <projekt>' benutzen."