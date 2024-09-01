#! /bin/bash

starfield_custom="StarfieldCustom.ini"
docs_folder=$1

echo "$docs_folder"
cd "$docs_folder" || exit

if ! [ -e $starfield_custom ]; then
    echo "Creating $starfield_custom"
    touch $starfield_custom
fi

if [ "$(grep -i "\[Archive\]" $starfield_custom -c)" = "0" ]; then
    echo "File contains no [Archive] section; generating"
    printf "[Archive]\nbInvalidateOlderFiles=1\nsResourceDataDirsFinal=\n" >> $starfield_custom
    exit
fi

binv_set=false
sres_set=false
current_section=""
line_number=1
while read -r line; do
    # Get the current section being read
    if ! [ "$(grep -i "\[[a-zA-Z0-9]*]" <<< "$line" -c)" = "0" ]; then
        current_section=$(grep -i "\[[a-zA-Z0-9]*]" <<< "$line" -o)
    # Search archive invalidation lines and correct them if the exist
    elif [ "${current_section,,}" = "[archive]" ]; then
        if ! [ "$(grep -i "bInvalidateOlderFiles=.*" <<< "$line" -c)" = "0" ]; then
            sed -i "${line_number}s/.*/bInvalidateOlderFiles=1/" $starfield_custom
            binv_set=true
        elif ! [ "$(grep -i "sResourceDataDirsFinal=.*" <<< "$line" -c)" = "0" ]; then
            sed -i "${line_number}s/.*/sResourceDataDirsFinal=/" $starfield_custom
            sres_set=true
        fi
    fi
    line_number=$((line_number+1))
done < $starfield_custom

if [ $binv_set = false ]; then
    section_start=$(grep -n -i "\[archive\]" $starfield_custom | grep "^." -o)
    sed -i "${section_start}s/.*/[Archive]\nbInvalidateOlderFiles=1/" $starfield_custom
    binv_set=true
fi
if [ $sres_set = false ]; then
    section_start=$(grep -n -i "\[archive\]" $starfield_custom | grep "^." -o)
    sed -i "${section_start}s/.*/[Archive]\nsResourceDataDirsFinal=/" $starfield_custom
    sres_set=true
fi
