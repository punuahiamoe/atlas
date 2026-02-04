#!/bin/bash

conv() {
  local img="$1"
  local dims width height
  if ! dims=$(identify -ping -format '%w %h' -- "${img}[0]" 2>/dev/null); then
    echo "identify failed for $img" >&2
    return 1
  fi
  read -r width height <<<"$dims"

  local target_w
  if (( width > height )); then
    target_w=2400
  elif (( height > width )); then
    target_w=1600
  else
    target_w=2000
  fi

  magick "$img" -auto-orient -filter Lanczos -resize "${target_w}x" \
    -unsharp 0x0.8+0.8+0.02 -strip -define webp:method=6 -quality 90 "${img%.jpg}.webp"
}

encrypt() {
    read -s -p "PIN " iter; echo

    gzip -9Nc $1 | openssl enc -aes-256-cbc -salt -pbkdf2 -md sha512 -iter $iter -out $2
}
