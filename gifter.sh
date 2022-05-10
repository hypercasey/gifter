#ffmpeg="/usr/bin/env ffmpeg"

uuid=$(uuidgen)

function convertToGIF () {
  if [[ -z $1 ]]; then
    echo "Error: Invalid source video path."
    exit $?
  else
    $ffmpeg -i $1 -filter_complex "[0:v] palettegen" /tmp/$uuid-palette.png
    $ffmpeg -i $1 -vf scale=1280:720,setsar=1:1 /tmp/$uuid-scaled.webm
    $ffmpeg -i /tmp/$uuid-scaled.webm -i /tmp/$uuid-palette.png -filter_complex "[0:v][1:v] paletteuse" ${1/webm/}gif
    rm /tmp/$uuid-palette.png /tmp/$uuid-scaled.webm
  fi
}

if [[ $@ ]]; then
  convertToGIF $@
else
  echo "Input source video path: "
  read sourceVideoPath
  convertToGIF $sourceVideoPath
fi
