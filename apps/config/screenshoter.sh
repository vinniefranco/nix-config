time=`date +%Y-%m-%d-%H-%M-%S`
geometry=`swaymsg -pt get_outputs | grep 'Current mode:' | cut -d':' -f2 | cut -d'@' -f1 | tr -d ' '`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"

 # notify and view screenshot
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"
notify_view () {
  ${notify_cmd_shot} "Copied to clipboard."
  satty --filename ${dir}/"$file"
  if [[ -e "$dir/$file" ]]; then
    ${notify_cmd_shot} "Screenshot Saved."
  else
    ${notify_cmd_shot} "Screenshot Deleted."
  fi

}
cd ${dir} && grim -g "$(slurp -d)" - | tee "$file" | wl-copy
notify_view
