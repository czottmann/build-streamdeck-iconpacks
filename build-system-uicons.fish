#!/usr/bin/env fish

source ./_functions.fish

set sdip_name 'System UIcons'
set sdip_slug 'system-uicons'

say_hello
set sdip_version (confirm_current_version)
setup_folder_variables
setup_working_folders


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


set icon_files (ls $build_dest_icon_folder/*.svg)
convert_all_svg_files_to_png $icon_files
remove_all_svg_build_files $icon_files

create_icons_json_file
create_manifest_json_file \
  --author "Carlo Zottmann (icon pack), Corey Ginnivan (original System UIcons)" \
  --desc "This is a free Stream Deck icon pack, based on the System UIcons iconset by Corey Ginnivan." \
  --icon 'icons/create.png' \
  --tags ''

optional_copy_to_local_sd_folder
optional_copy_to_dist_folder
# TODO: Ask to update website
remove_working_folders

echo "- Done!"
