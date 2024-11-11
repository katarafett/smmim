#! /bin/bash

docs_folder="$1"
starfield_custom="StarfieldCustom.ini"

if ! [ -e "$docs_folder" ]; then
    echo "$docs_folder not found"
    exit
fi

cd "$docs_folder" || exit

rm -rf "${docs_folder}/Data"

if ! [ -e $starfield_custom ]; then
    echo "Creating $starfield_custom"
    touch $starfield_custom
fi

if [ "$(grep -i "\[General\]" $starfield_custom -c)" = "0" ]; then
    echo "File contains no [General] section; generating"
    printf "[General]\nbEnableMessageOfTheDay=0\n" >> $starfield_custom
    exit
fi

current_section=""
line_number=1
while read -r line; do
    # Get the current section being read
    if ! [ "$(grep -i "\[[a-zA-Z0-9]*]" <<< "$line" -c)" = "0" ]; then
        current_section=$(grep -i "\[[a-zA-Z0-9]*]" <<< "$line" -o)
    # Search for disable motd lines and correct them if they exist
    elif [ "${current_section,,}" = "[general]" ]; then
        if ! [ "$(grep -i "bEnableMessageOfTheDay=.*" <<< "$line" -c)" = "0" ]; then
            sed -i "${line_number}s/.*/bEnableMessageOfTheDay=0/" $starfield_custom
        fi
    fi
    line_number=$((line_number+1))
done < $starfield_custom

# If no lines exist, make 'em
if [ "$(grep -i "bEnableMessageOfTheDay=0" -c $starfield_custom)" = "0" ]; then
    section_start=$(grep -n -i "\[general\]" $starfield_custom | grep "^." -o)
    sed -i "${section_start}s/.*/[General]\nbEnableMessageOfTheDay=0/" $starfield_custom
fi
