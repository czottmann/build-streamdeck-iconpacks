#!/usr/bin/env fish

source ./_functions.fish

set sdip_name "System UIcons"
set sdip_slug (slugify "$sdip_name")
set dest_folder_name "$sdip_slug.sdIconPack"
set sdip_version_file version.system-uicons.txt
set sdip_version (cat $sdip_version_file | string trim)

set build_folder (pwd)"/build/$sdip_slug"
set build_dest_folder "$build_folder/$dest_folder_name"
set build_dest_icon_folder "$build_folder/$dest_folder_name/icons"
set release_folder (pwd)"/dist/streamdeck-iconpack-system-uicons/$dest_folder_name"
set src_folder (pwd)"/src/$sdip_slug"
set tmp_folder (pwd)"/tmp/$sdip_slug"

echo "Preparing to build Stream Deck icon pack \"$sdip_name\""
echo

if not ask_for_confirmation --question "Version $sdip_version, correct?"
  set sdip_version (math $sdip_version + 0.1)
  if ask_for_confirmation --question "Bump version to $sdip_version?"
    echo "- Bumping version to $sdip_version"
    echo $sdip_version > $sdip_version_file
    git commit -m "[CHG] Bumps version" $sdip_version_file
  else
    echo "Exiting"
    exit 1
  end
end


echo "- Setting up folders"
rm -rf $build_folder $tmp_folder $src_folder >/dev/null 2>&1
mkdir -p $build_dest_folder $build_dest_icon_folder $tmp_folder $src_folder


echo "- Downloading icons from https://systemuicons.com/"
set zip_file $tmp_folder/system_icons.zip
curl --silent "https://systemuicons.com/images/System%20UIcons.zip" -o $zip_file
unzip -jq $zip_file -d $src_folder


echo "- Writing SVG build files"
cp (ls $src_folder/*.svg) $build_dest_icon_folder/
sd '"currentColor"' '"#fff"' (ls $build_dest_icon_folder/*.svg)

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
for svg_file in $extra_icons_red
  set --local svg_red (string replace ".svg" "__red.svg" (basename "$svg_file"))
  cp $svg_file $build_dest_icon_folder/$svg_red
end
sd '"currentColor"' '"#f00"' (ls "$build_dest_icon_folder"/*__red.svg)

set extra_icons_green $src_folder/info_circle.svg \
                      $src_folder/home_check.svg \
                      $src_folder/check_circle.svg \
                      $src_folder/check_circle_outside.svg \
                      $src_folder/checkbox_checked.svg \
                      $src_folder/clipboard_check.svg
for svg_file in $extra_icons_green
  set --local svg_green (string replace ".svg" "__green.svg" (basename "$svg_file"))
  cp $svg_file $build_dest_icon_folder/$svg_green
end
sd '"currentColor"' '"#0f0"' (ls $build_dest_icon_folder/*__green.svg)


echo "- Converting SVG build files to PNG"
set icon_files (ls $build_dest_icon_folder/*.svg)
for svg_file in $icon_files
  convert_svg_to_png --file $svg_file
end


echo "- Deleting SVG build files"
rm $icon_files


echo "- Building icons list"
png_list_to_json --folder $build_dest_icon_folder > $build_dest_folder/icons.json


echo "- Building manifest"
echo "{
  \"Author\": \"Carlo Zottmann (icon pack), Corey Ginnivan (original System UIcons)\",
  \"Description\": \"This is a free Stream Deck icon pack, based on the System UIcons iconset by Corey Ginnivan.\",
  \"Name\": \"$sdip_name\",
  \"URL\": \"https://streamdeck-iconpacks.czm.io\",
  \"Version\": \"$sdip_version\",
  \"Icon\": \"icons/create.png\",
  \"Tags\": \"\"
}" > $build_dest_folder/manifest.json


if ask_for_confirmation --question "Copy pack into SD IconPacks/ folder, possibly overwriting existing?"
  set sd_data_folder "$HOME/Library/Application Support/com.elgato.StreamDeck/IconPacks/$dest_folder_name"
  echo "- Copying icon pack to $sd_data_folder"
  rm -rf $sd_data_folder
  cp -R $build_dest_folder $sd_data_folder
end

if ask_for_confirmation --question "Copy pack into dist/ folder?"
  echo "- Copying icon pack to $release_folder"
  rm -rf $release_folder/* >/dev/null 2>&1
  cp -R $build_dest_folder/* $release_folder/
  cp $release_folder/../LICENSE.md $release_folder/
end

# TODO: Ask to update website

echo "- Cleaning up working folders"
rm -rf $build_folder $tmp_folder $src_folder >/dev/null 2>&1

echo "- Done!"
