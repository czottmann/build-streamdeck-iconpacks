#!/usr/bin/env fish

source ./_functions.fish

set sdip_name 'Fluent UI System Icons (Regular)'
set sdip_slug 'fluentui-system-icons-regular'

say_hello
set sdip_version (confirm_current_version)
setup_folder_variables
setup_working_folders


echo "- Downloading icons from Github"
set tgz_file $tmp_folder/fluentui-system-icons.tgz
curl --silent \
  "https://codeload.github.com/microsoft/fluentui-system-icons/tar.gz/refs/tags/1.1.142" \
  --output $tgz_file

echo "- Extracting icons from downloaded archive"
tar --extract \
  --directory $src_folder \
  --file $tgz_file \
  --include "**.svg" \
  --strip-components 1

echo "- Writing SVG build files"
for D in (fd 'SVG' --glob --type d --exact-depth 2 $src_folder/assets)
  set --local biggest_svg_file (fd 'regular' --fixed-strings --type f "$D" | tail -n 1)
  test -n "$biggest_svg_file" || continue
  test -f $biggest_svg_file || continue

  set --local new_name (basename $biggest_svg_file | sd 'ic_fluent_(.*)_\d+_(regular|filled)\.svg' '$1.svg')
  cp $biggest_svg_file $build_dest_icon_folder/$new_name
  echo -n "."
end
echo


echo "- Working SVG files"
sd ' fill="#212121"' ' fill="#ffffff"' (ls $build_dest_icon_folder/*.svg)

set extra_icons_red $build_dest_icon_folder/alert_off.svg \
                    $build_dest_icon_folder/arrow_repeat_all_off.svg \
                    $build_dest_icon_folder/arrow_sync_off.svg \
                    $build_dest_icon_folder/arrow_wrap_off.svg \
                    $build_dest_icon_folder/bluetooth_disabled.svg \
                    $build_dest_icon_folder/bookmark_off.svg \
                    $build_dest_icon_folder/briefcase_off.svg \
                    $build_dest_icon_folder/camera_off.svg \
                    $build_dest_icon_folder/cellular_data_cellular_off.svg \
                    $build_dest_icon_folder/chat_off.svg \
                    $build_dest_icon_folder/circle_off.svg \
                    $build_dest_icon_folder/closed_caption_off.svg \
                    $build_dest_icon_folder/cloud_off.svg \
                    $build_dest_icon_folder/cloud_offline.svg \
                    $build_dest_icon_folder/comment_off.svg \
                    $build_dest_icon_folder/convert_to_type_off.svg \
                    $build_dest_icon_folder/crop_interim_off.svg \
                    $build_dest_icon_folder/cursor_hover_off.svg \
                    $build_dest_icon_folder/delete_off.svg \
                    $build_dest_icon_folder/desktop_speaker_off.svg \
                    $build_dest_icon_folder/dialpad_off.svg \
                    $build_dest_icon_folder/document_bullet_list_off.svg \
                    $build_dest_icon_folder/document_split_hint_off.svg \
                    $build_dest_icon_folder/edit_off.svg \
                    $build_dest_icon_folder/equal_off.svg \
                    $build_dest_icon_folder/eye_off.svg \
                    $build_dest_icon_folder/eye_tracking_off.svg \
                    $build_dest_icon_folder/flag_off.svg \
                    $build_dest_icon_folder/flash_off.svg \
                    $build_dest_icon_folder/flashlight_off.svg \
                    $build_dest_icon_folder/glasses_off.svg \
                    $build_dest_icon_folder/hand_right_off.svg \
                    $build_dest_icon_folder/image_off.svg \
                    $build_dest_icon_folder/live_off.svg \
                    $build_dest_icon_folder/location_off.svg \
                    $build_dest_icon_folder/mail_off.svg \
                    $build_dest_icon_folder/megaphone_off.svg \
                    $build_dest_icon_folder/mic_off.svg \
                    $build_dest_icon_folder/money_off.svg \
                    $build_dest_icon_folder/open_off.svg \
                    $build_dest_icon_folder/pause_off.svg \
                    $build_dest_icon_folder/pin_off.svg \
                    $build_dest_icon_folder/presence_offline.svg \
                    $build_dest_icon_folder/presenter_off.svg \
                    $build_dest_icon_folder/record.svg \
                    $build_dest_icon_folder/record_stop.svg \
                    $build_dest_icon_folder/scan_thumb_up_off.svg \
                    $build_dest_icon_folder/scan_type_off.svg \
                    $build_dest_icon_folder/speaker_off.svg \
                    $build_dest_icon_folder/star_off.svg \
                    $build_dest_icon_folder/timer_off.svg \
                    $build_dest_icon_folder/video_360_off.svg \
                    $build_dest_icon_folder/video_off.svg \
                    $build_dest_icon_folder/video_person_off.svg \
                    $build_dest_icon_folder/video_person_star_off.svg \
                    $build_dest_icon_folder/weather_moon_off.svg \
                    $build_dest_icon_folder/wifi_off.svg \
                    $build_dest_icon_folder/window_ad_off.svg \
                    $build_dest_icon_folder/window_header_horizontal_off.svg \
                    $build_dest_icon_folder/calendar_error.svg \
                    $build_dest_icon_folder/calligraphy_pen_error.svg \
                    $build_dest_icon_folder/clipboard_error.svg \
                    $build_dest_icon_folder/comment_error.svg \
                    $build_dest_icon_folder/document_error.svg \
                    $build_dest_icon_folder/error_circle.svg \
                    $build_dest_icon_folder/line_horizontal_5_error.svg \
                    $build_dest_icon_folder/mail_error.svg \
                    $build_dest_icon_folder/notebook_error.svg \
                    $build_dest_icon_folder/people_error.svg \
                    $build_dest_icon_folder/shield_error.svg \
                    $build_dest_icon_folder/tag_error.svg \
                    $build_dest_icon_folder/text_grammar_error.svg
for svg_file in $extra_icons_red
  set --local svg_red (string replace ".svg" "__red.svg" (basename "$svg_file"))
  cp $svg_file $build_dest_icon_folder/$svg_red
end
sd ' fill="#ffffff"' ' fill="#ff0000"' (ls $build_dest_icon_folder/*__red.svg)

set extra_icons_green $build_dest_icon_folder/accessibility_checkmark.svg \
                      $build_dest_icon_folder/arrow_trending_checkmark.svg \
                      $build_dest_icon_folder/battery_checkmark.svg \
                      $build_dest_icon_folder/calendar_checkmark.svg \
                      $build_dest_icon_folder/call_checkmark.svg \
                      $build_dest_icon_folder/calligraphy_pen_checkmark.svg \
                      $build_dest_icon_folder/checkbox_1.svg \
                      $build_dest_icon_folder/checkbox_2.svg \
                      $build_dest_icon_folder/checkbox_checked.svg \
                      $build_dest_icon_folder/checkmark.svg \
                      $build_dest_icon_folder/checkmark_circle.svg \
                      $build_dest_icon_folder/checkmark_square.svg \
                      $build_dest_icon_folder/checkmark_starburst.svg \
                      $build_dest_icon_folder/checkmark_underline_circle.svg \
                      $build_dest_icon_folder/clipboard_checkmark.svg \
                      $build_dest_icon_folder/cloud_checkmark.svg \
                      $build_dest_icon_folder/comment_checkmark.svg \
                      $build_dest_icon_folder/comment_multiple_checkmark.svg \
                      $build_dest_icon_folder/document_checkmark.svg \
                      $build_dest_icon_folder/document_table_checkmark.svg \
                      $build_dest_icon_folder/flash_checkmark.svg \
                      $build_dest_icon_folder/home_checkmark.svg \
                      $build_dest_icon_folder/mail_checkmark.svg \
                      $build_dest_icon_folder/mail_inbox_checkmark.svg \
                      $build_dest_icon_folder/people_checkmark.svg \
                      $build_dest_icon_folder/phone_checkmark.svg \
                      $build_dest_icon_folder/phone_update_checkmark.svg \
                      $build_dest_icon_folder/production_checkmark.svg \
                      $build_dest_icon_folder/scan_type_checkmark.svg \
                      $build_dest_icon_folder/shield_checkmark.svg \
                      $build_dest_icon_folder/shifts_checkmark.svg \
                      $build_dest_icon_folder/text_grammar_checkmark.svg
for svg_file in $extra_icons_green
  set --local svg_green (string replace ".svg" "__green.svg" (basename "$svg_file"))
  cp $svg_file $build_dest_icon_folder/$svg_green
end
sd ' fill="#ffffff"' ' fill="#00ff00"' (ls $build_dest_icon_folder/*__green.svg)

set extra_icons_yellow $build_dest_icon_folder/battery_warning.svg \
                        $build_dest_icon_folder/cellular_warning.svg \
                        $build_dest_icon_folder/chat_warning.svg \
                        $build_dest_icon_folder/checkbox_warning.svg \
                        $build_dest_icon_folder/mail_warning.svg \
                        $build_dest_icon_folder/text_bullet_list_square_warning.svg \
                        $build_dest_icon_folder/warning.svg \
                        $build_dest_icon_folder/warning_shield.svg \
                        $build_dest_icon_folder/wifi_warning.svg
for svg_file in $extra_icons_yellow
  set --local svg_yellow (string replace ".svg" "__yellow.svg" (basename "$svg_file"))
  cp $svg_file $build_dest_icon_folder/$svg_yellow
end
sd ' fill="#ffffff"' ' fill="#ffff00"' (ls $build_dest_icon_folder/*__yellow.svg)


set icon_files (ls $build_dest_icon_folder/*.svg)
convert_all_svg_files_to_png --padding 7 $icon_files
remove_all_svg_build_files $icon_files

create_icons_json_file
create_manifest_json_file \
  --author "Carlo Zottmann (icon pack), Microsoft (original icons)" \
  --desc "A free icon pack based on Microsoft's Fluent UI System Icons.  Consists of "(count $icon_files)" icons." \
  --icon 'icons/fluent.png' \
  --tags 'microsoft, fluentui, fluent ui'

optional_copy_to_local_sd_folder
optional_copy_to_dist_folder
# TODO: Ask to update website
remove_working_folders

echo "- Done!"
