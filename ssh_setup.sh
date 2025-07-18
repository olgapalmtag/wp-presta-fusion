#!/bin/bash

echo "Starte SSH-Agent..."
eval "$(ssh-agent -s)"

KEY_PATH="$HOME/.ssh/wp-presta-key"

echo "Füge SSH-Key hinzu: $KEY_PATH"
if [ -f "$KEY_PATH" ]; then
  ssh-add "$KEY_PATH"
else
  echo "SSH-Key nicht gefunden unter $KEY_PATH"
  exit 1
fi

echo "Teste Verbindung zu GitHub..."
ssh -T git@github.com

echo "Setze Git-Konfiguration..."
git config --global user.name "olgapalmtag"
git config --global user.email "palmtag73@freenet.de"

echo "Führe git push origin main aus..."
#git push origin main

