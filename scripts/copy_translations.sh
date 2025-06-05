#!/bin/bash

# This script transforms translationfiles/<lang>/*.(po|mo)
# into the locale folder structure: <locale_dir>/<lang>/LC_MESSAGES/*.(po|mo)
# Usage: ./copy_translations.sh [locale_dir]
# Default locale_dir is "locale"

set -e

# Set locale directory (default to "locale")
LOCALE_DIR="${1:-locale}"

# Remove old translations if any
if [ -d "$LOCALE_DIR" ]; then
  echo "Cleaning existing contents of $LOCALE_DIR/"
  rm -rf "$LOCALE_DIR"/*
else
  echo "Creating $LOCALE_DIR/"
  mkdir -p "$LOCALE_DIR"
fi

# Loop through the translation folders
for lang_path in translationfiles/*; do
  if [ -d "$lang_path" ]; then
    lang=$(basename "$lang_path")
    if [ "$lang" != "templates" ]; then
      dest_dir="$LOCALE_DIR/$lang/LC_MESSAGES"
      mkdir -p "$dest_dir"
      echo "Copying $lang locale to $dest_dir"
      cp "$lang_path"/*.po "$dest_dir/" 2>/dev/null || true
      cp "$lang_path"/*.mo "$dest_dir/" 2>/dev/null || true
    fi
  fi
done

echo "Translations copied to $LOCALE_DIR"
