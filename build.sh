#!/bin/bash
index=0

if [[ -d assets ]]; then
    rm -rf assets
fi

mkdir assets

files=(
  MEM0
  RHE0
  MEM2
  MEM3
  STE0
  MEM6
  MEM1
  BLV0
  MEM5
  ALA0
  ARL0
  ARL1
  CRN0
  KLL1
  KLL0
  KLL2
  RHE1
  RHE2
  ALA1
  MEM8
  STE1
  AUG0
  AUG8
  AUG9
  AUG6
  AUG7
  MEM4
  MEM7
)

read -s -p "PIN " iter; echo
read -s -p "Pass " pass; echo

for file in "${files[@]}"; do
  cd data
  openssl enc -d -aes-256-cbc -salt -pbkdf2 -md sha512 -iter $iter -k $pass -in $file > tmp.gz
  gunzip -N tmp.gz
  img=$(ls *.webp | head -n 1)
  cd ..
  mv data/$img assets/$img

  if (( index % 2 == 0 )); then
    link=$( expr "$index" - 2)
    if (( link < 0 )); then
      echo "<img class=\"fit\" id=\"$index\" src=\"assets/$img\" title=\"$file:$img\"/>" > body.html
    else
      echo "<a href=\"#$link\"><img class=\"fit\" id=\"$index\" src=\"assets/$img\" title=\"$file:$img\"/></a>" >> body.html
    fi
  else
    link=$( expr "$index" + 2)
    echo "<a href=\"#$link\"><img class=\"fit\" id=\"$index\" src=\"assets/$img\" title=\"$file:$img\"/></a>" >> body.html
  fi

  index=$(( index + 1 ))
done

unset iter pass

export HTMLBODY=$( cat body.html )
awk '{gsub(/\${HTMLBODY}/, ENVIRON["HTMLBODY"], $0); print}' template.html > index.html
rm body.html
