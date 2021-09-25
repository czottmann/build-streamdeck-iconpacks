#!/opt/homebrew/bin/fish

# Dependencies:
# brew install csvtk fd jq sd slugify

set -l options (fish_opt -s h -l help)
set options $options (fish_opt --short b --long bg-color --long-only --required-val)
set options $options (fish_opt --short n --long name --long-only --required-val)
set options $options (fish_opt --short f --long fill-color --long-only --optional-val)
argparse $options -- $argv

if set --query _flag_help
or not set --query _flag_bg_color
or not set --query _flag_name
  echo "Usage: "(status --current-filename)" [OPTIONS]"
  echo
  echo "Options:"
  echo "  -h/--help           Prints help and exits"
  echo "  --name=ICONPACK     Name of the new icon pack, w/o the .sdIconPack extension"
  echo "  --bg-color=COLOR    Background color, e.g. #123abc or rgb(…)"
  echo "  --fill-color=COLOR  Fill color (optional)"
  exit 0
end

set build_folder "./build"
if test -d "$build_folder"
  rm -rf "$build_folder"
end

# Modify SVG files
set icon_folder "$build_folder/icons"
echo -n "- Creating build folder"
mkdir -p "$icon_folder"

echo -n "- Writing SVG files"
cp (ls src/*.svg) "$icon_folder/"
set icon_files (ls "$icon_folder"/*.svg)
sd 'viewBox="[\d ]+"' 'viewBox="-5 -5 34 34"' $icon_files
sd '("feather.+?">)' '$1<rect x="-50" y="-50" width="300" height="300" style="fill:'$_flag_bg_color';"/>' \
  $icon_files
if set --query _flag_fill_color
  sd ' fill="none"' ' fill="'"$_flag_fill_color"'"' $icon_files
end

echo "- Building icons list"
set tmp_file "$build_folder/tmp.csv"
echo "path" > "$tmp_file"
fd --base-directory "$icon_folder" --extension svg >> "$tmp_file"
csvtk csv2json "$tmp_file" \
  | jq 'map({ path, name: (.path | sub(".svg"; "")), tags: [] })' \
  > "$build_folder/icons.json"
rm "$tmp_file"

echo "- Building manifest"
echo "{
  \"Author\": \"Carlo Zottmann\",
  \"Description\": \"$_flag_name\",
  \"Name\": \"$_flag_name\",
  \"URL\": \"http://czm.io\",
  \"Version\": \"1.0\",
  \"Icon\": \"icons/feather.svg\",
  \"Tags\": \"\"
}" > "$build_folder/manifest.json"

set iconpack_folder "$HOME/Library/Application Support/com.elgato.StreamDeck/IconPacks/"(slugify "$_flag_name")".sdIconPack"
echo "- Moving icon pack to $iconpack_folder"
rm -rf "$iconpack_folder"
mv "$build_folder" "$iconpack_folder"

echo "- Done!"
