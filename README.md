# Tweaked NotePlan Themes

Tweak a [NotePlan][1] default theme programmatically using [`jq`][2] filters to change
the JSON file. This allows for updating after the default themes change.

[1]: https://noteplan.co/
[2]: https://jqlang.org/



## Changes that I make

These are the changes I make to Toothbleach and Orange:

- Title font sizes smaller: H1 is 20, H2 is 18, H3-H6 are 16
- Vertical space removed using https://github.com/tastapod/np-squash
- SFPro font used
- No title underlines in the Toothbleach theme
- Orange titles in the Orange theme

## How it works

The `np-tweak.py` file applies JQ script filter file to a given NotePlan theme
JSON file.

Running `np-tweak.py` will:

- Download the latest version of squash.jq if it doesn't exist
- Apply transformations to the theme file and save as `[basename]-tweaked.json`


The `tweak-from-default.sh` script shows how I use it:

```bash
./np-tweak.py \
    --output-dir "$output_dir" \
    --variable title1_size=20 \
    --variable body_size=None \
    --tweak "tweaks/squash.jq" \
    --tweak "tweaks/text-size.jq" \
    --tweak "tweaks/font-sfpro.jq" \
    --tweak "theme-specific/$theme.jq" \
    "$base_dir/$theme.json"
```

## np-tweak.py

### Requirements

`np-tweak.py` depends on `uv` from https://docs.astral.sh/uv/


### Usage

```bash  
./np-tweak.py [options] <theme-file>
```

Help info:


```bash    
./np-tweak.py -h
usage: np-tweak.py [-h] [--output-dir OUTPUT_DIR] [--name NAME] [--tweak TWEAK] [--variable VARIABLE] theme_file

Tweak NotePlan theme files by Rob Allen

positional arguments:
  theme_file            NotePlan theme file to process

options:
  -h, --help            show this help message and exit
  --output-dir OUTPUT_DIR
                        Output directory (default: current directory, use '-' for stdout)
  --name NAME           Custom name for the theme (default: original name + ' Tweaked')
  --tweak TWEAK         The jq tweak files to apply (repeat option for multiple files)
  --variable VARIABLE   Custom variables for jq filters in name=value format (repeat option for multiple variables)
```


## JQ Filter files

The `jq` app allows modifiying specific parts of a JSON file using filters. See
https://jqlang.org/manual/ for information.

The following filter files are provided:

`tweaks` folder:

- `font-sfpro.jq`: Sets the font to SFPro
- `font-user-from-settings.jq`: Enables control of the font from NotePlan's Editor settings
- `squash.jq`: Vertical space removal from https://github.com/tastapod/np-squash
- `text-size.jq`: Body and title font sizes set based on variables


`theme-specific` folder:

- `toothbleach.jq`: No title underlines in the Toothbleach theme.
- `default.jq`: Orange titles in the Orange theme.


You can of course write your own!

## Examples

If you just want to make the title font sizes a bit smaller on Orange:

```bash
# Set $base_dir to the NotePlan default themes directory

./np-tweak.py \
    --variable title1_size=22 \
    --variable body_size=16 \
    --tweak "tweaks/text-size.jq" \
    "$base_dir/default.json"

# Copy default-tweaked.json to your NotePlan user themes directory

```


## Directories

### NotePlan default themes directory

The default NotePlan themes are stored in the `Contents/Resources/themes`
directory of the application bundle. 

For the standard version:  
`/Applications/NotePlan.app/Contents/Resources/themes`


For the SetApp version:  
`/Applications/Setapp/NotePlan.app/Contents/Resources/themes`


### NotePlan user themes directory

Find this by clicking "Copy & Customize" in Settings→Themes.

For SetApp version:  
`"$HOME/Library/Containers/co.noteplan.NotePlan-setapp/Data/Library/Application Support/co.noteplan.NotePlan-setapp/Themes"`


## Copyright

- tweaks/squash.jq is copyright (c) Daniel Terhorst-North
