function ask_for_confirmation
  argparse 'q/question=' -- $argv
  or return

  if set -q _flag_question
    while true
      read --local --prompt-str "❓ $_flag_question [y/N] " answer
      switch $answer
        case Y y
          return 0
        case '' N n
          return 1
        end
    end
  end
end


function confirm_current_version
  set --local sdip_version_file "version.$sdip_slug.txt"
  set --local sdip_version (cat $sdip_version_file | string trim)

  if not ask_for_confirmation --question "Version $sdip_version, correct?"
    set --local sdip_version (math $sdip_version + 0.1)
    if ask_for_confirmation --question "Bump version to $sdip_version?"
      echo "- Bumping version to $sdip_version"
      echo $sdip_version > $sdip_version_file
      git commit -m "[CHG] Bumps version" $sdip_version_file
    else
      echo "Exiting"
      exit 1
    end
  end

  echo -n $sdip_version
end


function convert_all_svg_files_to_png
  argparse 'padding=+' -- $argv
  or return

  set --local icon_files $argv

  echo "- Converting" (count $icon_files) "SVG build files to PNG"
  if set -q _flag_padding
    for svg_file in $icon_files
      convert_svg_to_png --file $svg_file --padding $_flag_padding
    end
  else
    for svg_file in $icon_files
      convert_svg_to_png --file $svg_file
    end
  end
  echo
end


function convert_svg_to_png
  argparse 'file=+' 'padding=+' -- $argv
  or return

  set --local png_file (string replace '.svg' '.png' "$_flag_file")
  set --local width 144

  if set -q _flag_padding
    rsvg-convert \
      --format png \
      --keep-aspect-ratio \
      --output $png_file \
      --width (math "$width - $_flag_padding * 2") \
      $_flag_file
    convert \
      -background none \
      -gravity center \
      -extent $width"x"$width \
      $png_file \
      $png_file.new
    mv $png_file.new $png_file
    echo -n ':'
  else
    rsvg-convert \
      --format png \
      --keep-aspect-ratio \
      --output $png_file \
      --width $width \
      $_flag_file
    echo -n '.'
  end
end


function create_icons_json_file
  echo "- Creating icons.json file"

  set --local tmp_file $tmp_folder/icons.csv

  echo "_path" > $tmp_file
  fd --base-directory $build_dest_icon_folder --extension png >> $tmp_file
  sort $tmp_file > $tmp_file.new
  mv $tmp_file.new $tmp_file
  csvtk csv2json $tmp_file \
    | jq 'map({ path: ._path, name: (._path | sub(".png"; "") | gsub("_+"; " ")), tags: [] })' \
    > $build_dest_folder/icons.json
end


function create_manifest_json_file
  argparse 'a/author=' 'd/desc=' 'i/icon=' 't/tags=' -- $argv
  or return

  echo "- Creating manifest.json file"
  echo "{
          \"Author\": \"$_flag_author\",
          \"Description\": \"$_flag_desc\",
          \"Name\": \"$sdip_name\",
          \"URL\": \"https://streamdeck-iconpacks.czm.io\",
          \"Version\": \"$sdip_version\",
          \"Icon\": \"$_flag_icon\",
          \"Tags\": \"$_flag_tags\"
        }" \
    | jq \
    > $build_dest_folder/manifest.json
end


function optional_copy_to_dist_folder
  if ask_for_confirmation --question "Copy pack into dist/ folder?"
    echo "- Copying icon pack to $release_folder"
    rm -rf $release_folder/* >/dev/null 2>&1
    cp -R $build_dest_folder/* $release_folder/
    cp $release_folder/../LICENSE.md $release_folder/
  end
end


function optional_copy_to_local_sd_folder
  if ask_for_confirmation --question "Copy pack into SD IconPacks/ folder, possibly overwriting existing?"
    set --local sd_data_folder "$HOME/Library/Application Support/com.elgato.StreamDeck/IconPacks/$dest_folder_name"
    echo "- Copying icon pack to $sd_data_folder"
    rm -rf $sd_data_folder
    cp -R $build_dest_folder $sd_data_folder
  end
end


function remove_all_svg_build_files
  echo "- Deleting SVG build files"
  rm $argv
end


function remove_working_folders
  echo "- Cleaning up working folders"
  rm -rf $build_folder $tmp_folder $src_folder >/dev/null 2>&1
end


function say_hello
  echo "Preparing to build Stream Deck icon pack \"$sdip_name\""
  echo
end


function setup_folder_variables
  set --global dest_folder_name "$sdip_slug.sdIconPack"

  set --global build_folder (pwd)"/build/$sdip_slug"
  set --global build_dest_folder "$build_folder/$dest_folder_name"
  set --global build_dest_icon_folder "$build_folder/$dest_folder_name/icons"
  set --global release_folder (pwd)"/dist/streamdeck-iconpack-$sdip_slug/$dest_folder_name"
  set --global src_folder (pwd)"/src/$sdip_slug"
  set --global tmp_folder (pwd)"/tmp/$sdip_slug"
end


function setup_working_folders
  echo "- Setting up folders"
  rm -rf $build_folder $tmp_folder $src_folder >/dev/null 2>&1
  mkdir -p $build_dest_folder $build_dest_icon_folder $tmp_folder $src_folder
end
