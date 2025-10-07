#!/bin/bash
REPO="https://raw.githubusercontent.com/Team-Blauer-Creeper/cts/main/pkg"
PKG_DIR="$HOME/ct/pkg"
LOCAL_GIT="$HOME/cts"  # Lokaler GitHub-Ordner

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
    echo "echo 'Paket $name läuft!'" >> "$file"
    chmod +x "$file"

    # Editor öffnen
    if command -v nano &> /dev/null; then
      nano "$file"
    elif command -v vi &> /dev/null; then
      vi "$file"
    else
      echo "⚠️ Kein Editor gefunden!"
    fi

    echo "✅ Neues Paket '$name' wurde erstellt!"

    # === Automatisch in Git pushen ===
    if [ -d "$LOCAL_GIT/.git" ]; then
      cp "$file" "$LOCAL_GIT/pkg/"
      cd "$LOCAL_GIT"
      git add "pkg/$name.sh"
      git commit -m "Added package $name"
      git push
      cd ~
      echo "📤 Paket '$name' wurde auf GitHub hochgeladen!"
    else
      echo "⚠️ Kein Git-Repo unter $LOCAL_GIT gefunden — bitte klonen!"
    fi
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
    echo "  ct create            - Erstellt & lädt neues Paket hoch"
    echo "  ct delsystem         - Löscht CT-System"
    ;;
esac