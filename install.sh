#!/usr/bin/env bash
set -euo pipefail

sudo apt update && sudo apt install -y stow git zsh

cd "$(dirname "$0")"

for dir in bash zsh git nvim tmux bin; do
    echo "→ Stowing $dir"
    stow -v --target="$HOME" "$dir"
done

echo "✅ Dotfiles installed successfully!"

# Switch to zsh if not default
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    read -rp "Switch default shell to zsh? [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        chsh -s /usr/bin/zsh
        echo "Restart your terminal to use zsh."
    fi
fi


