#!/bin/bash

# This script compiles .po files to .mo files in-place
# Usage:
#   ./compile_po_to_mo.sh           # only compile if .mo is missing
#   ./compile_po_to_mo.sh --force   # force recompile even if .mo exists
#   ./compile_po_to_mo.sh -f        # same as above

FORCE=0

# Check CLI argument
if [[ "$1" == "--force" || "$1" == "-f" ]]; then
  FORCE=1
fi

cd translationfiles || { echo "Directory 'translationfiles' not found."; exit 1; }

for lang_dir in */; do
  [[ "$lang_dir" == "templates/" ]] && continue

  for po_file in "$lang_dir"*.po; do
    [[ -e "$po_file" ]] || continue

    mo_file="${po_file%.po}.mo"

    if [[ $FORCE -eq 1 || ! -f "$mo_file" ]]; then
      echo "Compiling $po_file -> $mo_file"
      msgfmt "$po_file" -o "$mo_file"
    else
      echo "$mo_file already exists, skipping."
    fi
  done
done
