#!/bin/bash
echo "🧩 Starte Installation des CT-Systems..."

# === Basisverzeichnis anlegen ===
mkdir -p $HOME/ct/pkg

# === ct-Befehl erstellen ===
cat << 'EOF' > $PREFIX/bin/ct
#!/bin/bash
REPO="https://raw.githubusercontent.com/Team-Blauer-Creeper/cts/main/pkg"
PKG_DIR="$HOME/ct/pkg"

case "$1" in
  install)
    if [ -z "$2" ]; then
      echo "❗ Nutzung: ct install <paket>"
      exit 1
    fi
    pkg="$2"
    localfile="$PKG_DIR/$pkg.sh"

    # Prüfe ob wget installiert ist
    if ! command -v wget &> /dev/null; then
      echo "🌐 wget wird installiert..."
      pkg install wget -y
    fi

    # Paket installieren
    if [ -f "$localfile" ]; then
      echo "📦 Paket '$pkg' ist bereits lokal vorhanden. Starte..."
      bash "$localfile"
    else
      echo "🌍 Lade '$pkg' von GitHub herunter..."
      wget -q -O "$localfile" "$REPO/$pkg.sh"
      if [ $? -eq 0 ]; then
        chmod +x "$localfile"
        echo "✅ Paket '$pkg' installiert!"
        bash "$localfile"
      else
        echo "❌ Fehler beim Herunterladen!"
        rm -f "$localfile"
      fi
    fi
    ;;

  create)
    read -p "🔧 Name des neuen Pakets: " name
    file="$PKG_DIR/$name.sh"
    echo "#!/bin/bash" > "$file"
    echo "echo 'Paket \$name läuft!'" >> "$file"
    chmod +x "$file"
    echo "✅ Neues Paket '$name' erstellt!"
    ;;

  delsystem)
    echo "⚠️  Lösche CT-System..."
    rm -rf "$HOME/ct"
    rm -f "$PREFIX/bin/ct"
    echo "✅ CT-System gelöscht."
    ;;

  *)
    echo "🧩 CT-System Befehle:"
    echo "  ct install <paket>   - Installiert und startet Paket"
    echo "  ct create            - Erstellt neues Paket"
    echo "  ct delsystem         - Löscht CT-System"
    ;;
esac
EOF

chmod +x $PREFIX/bin/ct

echo "✅ Installation abgeschlossen!"
echo "➡️  Du kannst jetzt 'ct install <paket>' nutzen."