#! /bin/zsh

starfieldcustom="StarfieldCustom.ini"
docs_folder=$1

echo $docs_folder
cd "$docs_folder"

if ! [ -e $starfieldcustom ]; then
    echo "Creating $starfieldcustom"
    touch $starfieldcustom
fi

if [ "$(grep -i "\[Archive\]" $starfieldcustom -c)" = "0" ]; then
    echo "File contains no [Archive] section; generating"
    printf "[Archive]\nbInvalidateOlderFiles=1\nsResourceDataDirsFinal=\n" > $starfieldcustom
    return 0
fi

current_section=""
line_number=1
while read -r line; do
    if ! [ "$(grep -i "\[[a-zA-Z0-9]*]" <<< $line -c)" = "0" ]; then
        current_section=$(grep -i "\[[a-zA-Z0-9]*]" <<< $line -o)
    elif [ "${current_section:l}" = "[archive]" ]; then
        if ! [ "$(grep -i "bInvalidateOlderFiles=.*" <<< $line -c)" = "0" ]; then
            sed -i "${line_number}s/.*/bInvalidateOlderFiles=1/" $starfieldcustom
        elif ! [ "$(grep -i "sResourceDataDirsFinal=.*" <<< $line -c)" = "0" ]; then
            sed -i "${line_number}s/.*/sResourceDataDirsFinal=/" $starfieldcustom
        fi
    fi
    line_number=$((line_number+1))
done < $starfieldcustom
