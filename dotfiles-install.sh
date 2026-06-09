#!/usr/bin/env bash
# Symlinks this repo's files into ~ . Safe + idempotent (backs up real files to *.bak).
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ok(){ printf "  \033[1;32m✓\033[0m %s\n" "$1"; }; skip(){ printf "    skip %s\n" "$1"; }
IGNORE=( ".git" ".github" ".gitignore" "README" "README.md" "LICENSE" "Brewfile" \
         "Brewfile.lock.json" "dotfiles-install.sh" "install.sh" "bootstrap.sh" \
         "setup.sh" "Makefile" ".DS_Store" )
is_ignored(){ local n="$1"; for ig in "${IGNORE[@]}"; do [ "$n" = "$ig" ] && return 0; done; return 1; }
link(){ local src="$1" dst="$2"; mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then rm "$dst"; elif [ -e "$dst" ]; then mv "$dst" "$dst.bak"; ok "backed up $dst -> $dst.bak"; fi
  ln -s "$src" "$dst"; ok "${dst/#$HOME/~} -> ${src/#$HOME/~}"; }
printf "\nLinking dotfiles from: %s\n\n" "$REPO"
shopt -s dotglob nullglob
for path in "$REPO"/*; do
  name="$(basename "$path")"; is_ignored "$name" && { skip "$name"; continue; }
  if [ "$name" = ".config" ] && [ -d "$path" ]; then
    for sub in "$path"/*; do link "$sub" "$HOME/.config/$(basename "$sub")"; done
  else link "$path" "$HOME/$name"; fi
done
shopt -u dotglob nullglob
printf "\nDone. *.bak files are my previous configs.\n"
