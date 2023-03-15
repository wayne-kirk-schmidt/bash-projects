#!/usr/bin/bash

umask 022
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin:$PATH"

input_file=$1

unset markets
declare -A markets

[ -f $input_file ] && {
    while read market trade ; do (( markets[$market]+=$trade )); done <<< $( cat $input_file | awk -F, '{print$1, $2}' )
    for key in "${!markets[@]}"; 
    do 
        echo $key ${markets[$key]}; 
    done
}
