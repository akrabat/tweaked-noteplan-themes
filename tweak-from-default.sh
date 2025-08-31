#!/usr/bin/env bash

set -eo pipefail

base_dir="/Applications/Setapp/NotePlan.app/Contents/Resources/themes"
default_output_dir="$HOME/Library/Containers/co.noteplan.NotePlan-setapp/Data/Library/Application Support/co.noteplan.NotePlan-setapp/Themes"

theme="$1"
output_dir="${2:-$default_output_dir}"

if [[ -z "$theme" ]]; then
  echo "Usage: $0 <theme-name> [output-dir]"
  echo ""
  echo "  theme-name is the filename of a NotePlan theme (excluding the .json)"
  echo "  output-dir is optional output directory (defaults to NotePlan Setapp user themes)"
  exit 1
fi

./np-tweak.py \
    --output-dir "$output_dir" \
    --variable title1_size=20 \
    --variable body_size=None \
    --tweak "tweaks/squash.jq" \
    --tweak "tweaks/text-size.jq" \
    --tweak "tweaks/font-sfpro.jq" \
    --tweak "theme-specific/$theme.jq" \
    "$base_dir/$theme.json"
