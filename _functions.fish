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


function convert_svg_to_png
  argparse 'f/file=' -- $argv
  or return

  rsvg-convert \
    --format png \
    --keep-aspect-ratio \
    --output (string replace '.svg' '.png' "$_flag_file") \
    --width 144 \
    $_flag_file
end


function png_list_to_json
  argparse 'f/folder=' -- $argv
  or return

  test -d tmp/ || mkdir tmp/
  set --local tmp_file tmp/icons.csv

  echo "path" > $tmp_file
  fd --base-directory $_flag_folder --extension png >> $tmp_file
  csvtk csv2json $tmp_file \
    | jq 'map({ path, name: (.path | sub(".png"; "") | gsub("_+"; " ")), tags: [] })'
end
