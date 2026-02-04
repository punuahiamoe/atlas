#!/bin/bash
index=0

files=(
  AUG1
  AUG2
  AUG5
  AUG3
  AUG4
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

  link=$( expr "$index" + 1)
  echo "<a href=\"#$link\"><img class=\"fit\" id=\"$index\" src=\"assets/$img\" title=\"$file:$img\"/></a>" >> body.html

  index=$(( index + 1 ))
done

unset iter pass

export HTMLBODY=$( cat body.html )
awk '{gsub(/\${HTMLBODY}/, ENVIRON["HTMLBODY"], $0); print}' template.html > wide.html
rm body.html

