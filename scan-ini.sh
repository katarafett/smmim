#! /bin/zsh

# Check if enough arguments are passed
if [ "$1" = "" ] || [ "$2" = "" ]; then
    echo "Not enough arguments"
    return 1
fi

in_file=$1
out_dir=$2

# Check that files exist
if ! [ -e $in_file ]; then
    echo "$in_file not found"
    return 2
fi
if ! [ -e $out_dir ]; then
    echo "$out_dir not found"
    return 2
fi

# Create new file for each section, and put section contents in each file
/bin/rm --force "$out_dir/"*
out_file=""
while read -r line; do
    if ! [ "$(grep "\[.*\]" <<< $line -c)" = "0" ]; then
        out_file=$(grep "[a-zA-Z]*" <<< $line -o)
        echo "" >> "$out_dir/$out_file"
    elif ! [ "$out_file" = "" ]; then
        echo "$line" >> $out_dir/$out_file
    fi
done < $in_file
