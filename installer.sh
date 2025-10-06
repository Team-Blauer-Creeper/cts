#!/bin/bash
# ==========================================
# Team-Blauer-Creeper - BetterBank Installer
# ==========================================

BIN_DIR="$PREFIX/bin"
PKG_DIR="$HOME/pkg/betterbank"
DATA_DIR="$PKG_DIR/betterbankdata"

mkdir -p "$BIN_DIR"
mkdir -p "$DATA_DIR"

# ------------------------
# Daten-Datei erstellen
# ------------------------
DATA_FILE="$DATA_DIR/data.py"
if [ ! -f "$DATA_FILE" ]; then
    cat <<'EOF' > "$DATA_FILE"
#!/usr/bin/env python3
# BetterBank Data File
users = {}  # Benutzername -> [passhash, balance]
EOF
    chmod +x "$DATA_FILE"
fi

# ------------------------
# Bank-Befehl erstellen
# ------------------------
BANK_CMD="$BIN_DIR/bank"
cat <<'EOF' > "$BANK_CMD"
#!/bin/bash
CMD="$1"
shift
PKG_DIR="$HOME/pkg/betterbank"
DATA_DIR="$PKG_DIR/betterbankdata"
DATA_FILE="$DATA_DIR/data.py"

if [ "$CMD" = "login" ]; then
    python3 <<'PY'
import os, sys, hashlib, time
sys.path.insert(0, os.path.expanduser("~/pkg/betterbank/betterbankdata"))
import data

def hash_pass(p): return hashlib.sha256(p.encode()).hexdigest()

def save_data():
    with open(data.__file__, "w") as f:
        f.write("# BetterBank Data File\nusers = {\n")
        for u, v in data.users.items():
            f.write(f"    '{u}': {v},\n")
        f.write("}\n")

def loading(text="Lade...", steps=20):
    print(text)
    for i in range(steps):
        print("#", end="", flush=True)
        time.sleep(0.05)
    print(" ✅")

while True:
    print("\n💙 BetterBank")
    print("1) Registrieren 2) Login 3) Exit")
    c = input("Option: ")
    if c=="1":
        u = input("Benutzername: ")
        p = input("Passwort: ")
        ph = hash_pass(p)
        if u in data.users:
            print("❌ Benutzer existiert bereits!")
        else:
            data.users[u] = [ph, 0]
            loading("Konto wird erstellt...")
            save_data()
            print("✅ Konto erstellt! Automatisch eingeloggt.")
            user = u
            break
    elif c=="2":
        u = input("Benutzername: ")
        p = input("Passwort: ")
        ph = hash_pass(p)
        if u in data.users and data.users[u][0]==ph:
            print("🔓 Login erfolgreich!")
            user = u
            break
        else:
            print("❌ Falscher Benutzer/Passwort!")
    elif c=="3":
        exit(0)
    else:
        print("❌ Ungültige Option!")

# Eingeloggt: Hauptmenü
while True:
    bal = data.users[user][1]
    print(f"\n💙 Benutzer: {user} | Kontostand: {bal}€")
    print("1) Einzahlen 2) Abheben 3) Überweisen 4) Logout 5) Exit")
    opt = input("Option: ")
    if opt=="1":
        amt = int(input("Betrag einzahlen: "))
        data.users[user][1] += amt
        loading(f"{amt}€ eingezahlt...")
        save_data()
    elif opt=="2":
        amt = int(input("Betrag abheben: "))
        if amt>data.users[user][1]:
            print("❌ Nicht genug Guthaben!")
        else:
            data.users[user][1] -= amt
            loading(f"{amt}€ abgehoben...")
            save_data()
    elif opt=="3":
        to = input("Empfänger: ")
        amt = int(input("Betrag: "))
        if to not in data.users:
            print("❌ Benutzer existiert nicht!")
        elif amt>data.users[user][1]:
            print("❌ Nicht genug Guthaben!")
        else:
            data.users[user][1] -= amt
            data.users[to][1] += amt
            loading(f"{amt}€ an {to} überwiesen...")
            save_data()
    elif opt=="4":
        print("🔒 Logout...")
        break
    elif opt=="5":
        print("👋 Bye!")
        exit(0)
    else:
        print("❌ Ungültige Option!")
PY
else
    echo "Verwendung: bank login"
fi
EOF

chmod +x "$BANK_CMD"

echo "✅ BetterBank installiert!"
echo "→ Verwende 'bank login', um das Menü zu starten."