#!/bin/bash

file=$1

if [ ! -f "$file" ]
then
    echo "File $file does not exists"
    exit 0;
fi

zipinfo=$(zipinfo -l "$file")
ftypes=$(echo "$zipinfo" | grep -E ".*\.[a-zA-Z0-9]*$" | sed -e 's/.*\(\.[a-zA-Z0-9]*\)$/\1/' | sort | uniq)

for ft in $ftypes
do
    echo -n "$ft"
    echo "$zipinfo" | grep -E "${ft}" | awk '{uncompressed += $4; compressed += $6} END {printf "\t%s\t%s\n", uncompressed, compressed}'
done
