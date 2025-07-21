#!/bin/bash

echo "Starting SSH Agent..."
eval "$(ssh-agent -s)"

KEY_PATH="$HOME/.ssh/wp-presta-key"

echo "Adding SSH key: $KEY_PATH"
if [ -f "$KEY_PATH" ]; then
  ssh-add "$KEY_PATH"
else
  echo "SSH key not found at $KEY_PATH"
  exit 1
fi

echo "Testing connection to GitHub..."
ssh -o StrictHostKeyChecking=no -T git@github.com

echo "Setting Git config..."
git config --global user.name "olgapalmtag"
git config --global user.email "palmtag73@freenet.de"

echo "Running git push..."
git push origin main

