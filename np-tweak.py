#!/usr/bin/env -S uv run --script --quiet
# /// script
# dependencies = ["hjson", "requests", "jq"]
# ///

import sys
import os
import argparse
import hjson
import jq
import json
import re
import requests

from datetime import datetime
from pathlib import Path

def download_squash_jq():
    """Download squash.jq if it doesn't exist."""
    if not Path("tweaks/squash.jq").exists():
        url = "https://github.com/tastapod/np-squash/raw/refs/heads/main/squash.jq"
        response = requests.get(url)
        response.raise_for_status()
        
        current_datetime = datetime.now().strftime("%Y-%m-%d at %H:%M")
        copyright_header = f"# Copyright (c) Daniel Terhorst-North\n# Downloaded from https://github.com/tastapod/np-squash on {current_datetime}\n\n"
        
        with open("tweaks/squash.jq", "w") as f:
            f.write(copyright_header + response.text)


def jq_string(data, filter_string, variables=None):
    """Run jq filter string on data using Python jq library."""
    if variables:
        result = jq.compile(filter_string, variables).input(json.loads(data)).first()
    else:
        result = jq.compile(filter_string).input(json.loads(data)).first()

    return json.dumps(result, indent=2)


def jq_file(data, filter_file, variables=None):
    """Run jq filter on data using Python jq library."""
    with open(filter_file, "r") as f:
        filter_content = f.read()

    # Append the name to the tweakedBy.tweaks array
    filter_name = Path(filter_file).name
    tracking_filter = f'.tweakedBy.tweaks += ["{filter_name}"]'
    combined_filter = filter_content + "\n | " + tracking_filter

    return jq_string(data, combined_filter, variables)


def main():
    parser = argparse.ArgumentParser(description="Tweak NotePlan theme files by Rob Allen")
    parser.add_argument("theme_file", help="NotePlan theme file to process")
    parser.add_argument("--output-dir", default=".", help="Output directory (default: current directory, use '-' for stdout)")
    parser.add_argument("--name", help="Custom name for the theme (default: original name + ' Tweaked')")
    parser.add_argument("--tweak", action="append", help="The jq tweak files to apply (repeat option for multiple files)")
    parser.add_argument("--variable", action="append", help="Custom variables for jq filters in name=value format (repeat option for multiple variables)")
    
    args = parser.parse_args()
    
    themefile = args.theme_file
    outputdirectory = args.output_dir
    custom_name = args.name
    tweaks = args.tweak or []
    
    # Get base name of themefile
    basename = Path(themefile).stem
    if custom_name:
        # Convert custom name to lowercase underscore-separated filename
        filename = custom_name.lower().replace(" ", "_")
        # Remove illegal characters for filenames
        filename = re.sub(r'[<>:"/\\|?*]', '', filename)
        newthemefile = Path(outputdirectory) / f"{filename}.json"
    else:
        newthemefile = Path(outputdirectory) / f"{basename}-tweaked.json"
    
    # Print starting message if not outputting to stdout
    if outputdirectory != "-":
        print(f"Processing {basename}.json...")
        if custom_name:
            print(f"Custom name: {custom_name}")
        print("Output directory:", outputdirectory)
        print()

    # Download squash.jq
    download_squash_jq()
    
    # Read and convert hjson to json
    with open(themefile, "r") as f:
        theme_data = hjson.load(f)
    
    # Convert to JSON string preserving order
    json_data = json.dumps(theme_data)
    
    # Check if theme has a name property
    if "name" not in theme_data:
        print(f"Error: Theme file '{themefile}' does not have a 'name' property", file=sys.stderr)
        sys.exit(2)

    # Extract name from theme data
    name = theme_data["name"]

    # Set up variables
    variables = {}
    arg_variables = args.variable or []
    for var_str in arg_variables:
        if "=" in var_str:
            var_name, var_value = var_str.split("=", 1)
            # Handle special case for None
            if var_value == "None":
                variables[var_name] = None
            else:
                # Try to convert to int if possible, otherwise keep as string
                try:
                    variables[var_name] = int(var_value)
                except ValueError:
                    variables[var_name] = var_value
        else:
            print(f"Warning: Invalid variable format '{var_str}', expected name=value", file=sys.stderr)

    # Add tweakedBy block
    tweaked_data = jq_string(json_data, """. += {
        tweakedBy: {
            name: "np-tweak",
            date: (now | todateiso8601)
        }
    }""")


    # Apply tweaks
    for tweak_file in tweaks:
        if Path(tweak_file).exists():
            if outputdirectory != "-":
                print(f"Applying tweak from {tweak_file}...")
            tweaked_data = jq_file(tweaked_data, tweak_file, variables)
        else:
            print(f"Warning: '{tweak_file}' not found, skipping.", file=sys.stderr)


    # Set final theme name
    final_name = custom_name if custom_name else f"{name} Tweaked"
    tweaked_data = jq_string(tweaked_data, f'.name = "{final_name}"')

    # Write to output file or stdout
    if outputdirectory == "-":
        print(tweaked_data.strip())
    else:
        with open(newthemefile, "w") as f:
            f.write(tweaked_data.strip())
        print()
        print(f"Done. Created '{final_name}' theme ({Path(newthemefile).name})")


if __name__ == "__main__":
    main()
