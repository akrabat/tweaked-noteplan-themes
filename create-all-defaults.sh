#!/usr/bin/env bash

set -euo pipefail


base_dir="/Applications/Setapp/NotePlan.app/Contents/Resources/themes"
output_dir="tweaked-themes"


exclude_files=("markdown-regex")
font_exclude_themes=("Monospace-Light" "toothbleach-condensed" "toothpaste-condensed")

# Create directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate over all JSON files in the NotePlan themes directory
for theme_file in "$base_dir"/*.json; do
    if [ -f "$theme_file" ]; then
        # Extract basename without extension
        basename=$(basename "$theme_file" .json)

        if [[ " ${exclude_files[*]} " =~ ${basename} ]]; then
            echo "Skipping excluded file: $basename"
            continue
        fi
        
        # Exclude change to SFPro for themes in font_exclude_themes list
        if [[ " ${font_exclude_themes[*]} " =~ ${basename} ]]; then
            ./np-tweak.py \
                --output-dir "$output_dir" \
                --variable title1_size=20 \
                --variable body_size=None \
                --tweak "tweaks/squash.jq" \
                --tweak "tweaks/text-size.jq" \
                --tweak "theme-specific/$basename.jq" \
                "$base_dir/$basename.json"
            continue
        fi
        
        ./tweak-from-default.sh "$basename" "tweaked-themes"
    fi
done
