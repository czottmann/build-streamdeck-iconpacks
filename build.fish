#!/opt/homebrew/bin/fish

# Dependencies:
# brew install csvtk fd jq sd slugify librsvg

set iconpack_name "System UIcons"

# Setup folders
set build_folder "./build"
set icon_folder "$build_folder/icons"
set src_folder "./src"
set tmp_folder "./tmp"

echo "- Setting up folders"
rm -rf "$build_folder" "$tmp_folder" "$src_folder" >/dev/null 2>&1
mkdir -p "$build_folder" "$icon_folder" "$tmp_folder" "$src_folder"


echo "- Downloading icons from website"
set zip_file "$tmp_folder/system_icons.zip"
curl --silent "https://systemuicons.com/images/System%20UIcons.zip" -o "$zip_file"
unzip -jq "$zip_file" -d "$src_folder"


echo "- Writing SVG build files"
cp (ls "$src_folder"/*.svg) "$icon_folder/"
sd '"currentColor"' '"#fff"' (ls "$icon_folder"/*.svg)

set extra_icons_red $src_folder/bell_disabled.svg \
                    $src_folder/camera_noflash_alt.svg \
                    $src_folder/camera_noflash.svg \
                    $src_folder/cloud_disconnect.svg \
                    $src_folder/cross.svg \
                    $src_folder/cross_circle.svg \
                    $src_folder/heart_remove.svg \
                    $src_folder/eye_no.svg \
                    $src_folder/microphone_disabled.svg \
                    $src_folder/microphone_muted.svg \
                    $src_folder/record.svg \
                    $src_folder/volume_disabled.svg \
                    $src_folder/volume_muted.svg \
                    $src_folder/warning_circle.svg \
                    $src_folder/warning_hex.svg \
                    $src_folder/warning_triangle.svg \
                    $src_folder/wifi_none.svg
for F in $extra_icons_red
  set --local new_name (string replace ".svg" "__red.svg" (basename "$F"))
  cp "$F" "$icon_folder/$new_name"
end
sd '"currentColor"' '"#f00"' (ls "$icon_folder"/*__red.svg)

set extra_icons_green $src_folder/info_circle.svg \
                      $src_folder/home_check.svg \
                      $src_folder/check_circle.svg \
                      $src_folder/check_circle_outside.svg \
                      $src_folder/checkbox_checked.svg \
                      $src_folder/clipboard_check.svg
for F in $extra_icons_green
  set --local new_name (string replace ".svg" "__green.svg" (basename "$F"))
  cp "$F" "$icon_folder/$new_name"
end
sd '"currentColor"' '"#0f0"' (ls "$icon_folder"/*__green.svg)


echo "- Converting SVG build files to PNG"
set icon_files (ls "$icon_folder"/*.svg)
for F in $icon_files
  rsvg-convert --height 144 "$F" > (string replace ".svg" ".png" "$F")
end


echo "- Deleting SVG build files"
rm $icon_files


echo "- Building icons list"
set tmp_file "$tmp_folder/icons.csv"
echo "path" > "$tmp_file"
fd --base-directory "$icon_folder" --extension png >> "$tmp_file"
csvtk csv2json "$tmp_file" \
  | jq 'map({ path, name: (.path | sub(".png"; "") | gsub("_+"; " ")), tags: [] })' \
  > "$build_folder/icons.json"


echo "- Building manifest"
echo "{
  \"Author\": \"Carlo Zottmann (icon pack), Corey Ginnivan (original System UIcons)\",
  \"Description\": \"$iconpack_name\",
  \"Name\": \"$iconpack_name\",
  \"URL\": \"https://streamdeck-iconpacks.czm.io\",
  \"Version\": \"1.1\",
  \"Icon\": \"icons/create.png\",
  \"Tags\": \"\"
}" > "$build_folder/manifest.json"


set iconpack_folder "$HOME/Library/Application Support/com.elgato.StreamDeck/IconPacks/"(slugify "$iconpack_name")".sdIconPack"
echo "- Moving icon pack to $iconpack_folder"
rm -rf "$iconpack_folder"
mv "$build_folder" "$iconpack_folder"

echo "- Done!"
