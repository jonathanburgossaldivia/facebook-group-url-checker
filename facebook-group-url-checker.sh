#!/bin/bash

declare validUrl_list=()
declare idUrl_list=()

input=$1
echo  >> "$input"

while IFS= read -r line
do
  check=$(curl -L "$line" 2>&1 | grep "^<title>")
  if [ -z "$check" ]
  then
    echo "$line = url not valid"
  else
    valid=$(echo "$check" | sed 's/[<|\/>]//g;s/title//g')
    echo "$line = $valid"
    id_url=$(echo "$line" | sed 's/www\.facebook\.com\/groups\///g' )
    validUrl_list=("${validUrl_list[@]}" "$line")
    idUrl_list=("${idUrl_list[@]}" "$id_url")
  fi
done < "$input"

echo "Valid url list"
for i in "${validUrl_list[@]}"
do
    echo "$i"
done

echo "Only ID of url list"
for i in "${idUrl_list[@]}"
do
  printf '%s' "$i "
done

perl -pi -e 'chomp if eof' "$input"
