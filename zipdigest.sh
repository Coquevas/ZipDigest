#!/bin/bash

######## Functions ########
# Taken from http://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array
function join_strings { 
    local d=$1; 
    shift; 
    echo -n "$1"; 
    shift; 
    printf "%s" "${@/#/$d}";
}

# Sorts and uniques a list of lines
function unifier {
	local list=$1
	echo "$list" | sort | uniq
}

function parse_zipinfo {
	local zinfo=$1
	local regex=$2

	echo "$zinfo" | grep -E "$regex" | awk '{uncompressed += $4; compressed += $6} END {printf "\t%s\t%s\n", uncompressed, compressed}'
}

######## Main ########

file=$1

if [ ! -f "$file" ]
then
    echo "File $file does not exists"
    exit 0;
fi

zipinfo=$(zipinfo -l "$file")

# File extensions
ftypes=$(unifier "$(echo "$zipinfo" | grep -E ".*\.[a-zA-Z0-9]*$" | sed -e 's/.*\(\.[a-zA-Z0-9]*\)$/\1/')")

# Files without extension
others=$(unifier "$(echo "$zipinfo" | grep -E ".*\/[a-zA-Z0-9]*$" | sed -e 's/.*\/\([a-zA-Z0-9]*\)$/\1/')")

for ft in $ftypes
do
    echo -n "$ft"
    parse_zipinfo "$zipinfo" $ft
done

echo -n "Others"
others_regex="($(join_strings "|" $others))$"
parse_zipinfo "$zipinfo" $others_regex
