#!/bin/bash

# Takes the input of chr22.fa. Remove the first line. Then grep either G, C, g or c and output each char as a line.
# Count the number of output lines.

ceil() {
    printf "%.0f" "${1}"
}

isHighGC() {
    N=$1
    STR=$2
    # string have more than N C or G no matter whether they are in a chain (i.e., they are in consequence)
    REGEX="([^C|^c|^G|^g]*(C|c|G|g)){$N}"
    echo $(echo $STR | grep -Ec $REGEX)
}

main() {
    sp="/-\|"
    K=$1
    COUNT=0
    i=1
    INPUT=$(grep -v ">" chr22.fa | tr -d "\s\r,\n,\t,\r\n,\r")
    LEN=${#INPUT}
    N=$(ceil $(echo "scale=0; $K*0.7" | bc -l))
    while [[ $(($i + $K)) -le $LEN ]]; do
        END=$(($i + $K - 1))
        SUB=${INPUT:i:K}
        printf "\r\033[K\b${sp:i%${#sp}:1} [%d/%d](%3.2f)%% | No. of high GC: %d" "$END" "$LEN" $(($END / $LEN * 100)) "$COUNT"
        flag=$(isHighGC $(($N + 1)) $SUB)
        if [[ $flag -gt 0 ]]; then
            ((COUNT++))
        fi
        ((i++))
    done
    echo $COUNT
}

main 100
