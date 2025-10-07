#!/bin/bash
echo "🚀 Installiere CT-System..."

# Stelle sicher, dass wget da ist
if ! command -v wget &> /dev/null; then
  echo "🌐 Installiere wget..."
  pkg install wget -y
fi

# Verzeichnisse erstellen
mkdir -p $HOME/ct/pkg

# Hauptdatei ct.sh laden
echo "📥 Lade ct.sh herunter..."
wget -q -O $HOME/ct/ct.sh https://raw.githubusercontent.com/Team-Blauer-Creeper/cts/main/ct.sh

# Falls Download fehlgeschlagen
if [ ! -s "$HOME/ct/ct.sh" ]; then
  echo "❌ Download von ct.sh fehlgeschlagen!"
  exit 1
fi

chmod +x $HOME/ct/ct.sh

# Symbolischen Link im Bin-Verzeichnis erstellen
ln -sf $HOME/ct/ct.sh $PREFIX/bin/ct

# Testen ob der Befehl funktioniert
if command -v ct &> /dev/null; then
  echo "✅ CT-System erfolgreich installiert!"
  echo "👉 Starte mit: ct"
else
  echo "⚠️ Etwas stimmt nicht — versuche Termux neu zu starten!"
fi