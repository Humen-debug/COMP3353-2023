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

    INPUT=$(grep -v ">" chr22.fa | tr -d "\s\r,\n,\t,\r\n,\r")
    # number of characters per line without newline character
    LIMIT=$(grep -v ">" chr22.fa | head -n 1 | tr -d "\s\r,\n,\t,\r\n,\r" | wc -c)

    LEN=${#INPUT}
    N=$(ceil $(echo "scale=0; $K*0.7" | bc -l))
    COUNT=0
    SUB=${INPUT:0:K}
    # count gc content per substring. Only use grep at the beginning as we will then
    # count it one by one character.
    GC=$(echo $SUB | grep -oE "[C|G|c|g]" | wc -l)
    # masked output
    OUTPUT=""
    PAT="[G|C|g|c]"
    for ((i = 1; i <= $LEN - $K; i++)); do

        END=$(($i + $K - 1))
        HEAD=${SUB:0:1}
        NEXT=${INPUT:END:1}
        SUB=${SUB:1}$NEXT
        if [[ $HEAD =~ $PAT ]]; then
            ((GC--))
        fi
        if [[ $NEXT =~ $PAT ]]; then
            ((GC++))
        fi
        # mask the substring with N or n if it is high GC-content
        if [[ $GC -gt $N ]]; then
            MASKED=$(echo $SUB | tr 'GCgc' 'NNnn')
            OUTPUT="${OUTPUT:0:i-1}$MASKED"
            ((COUNT++))
        else
            OUTPUT="$OUTPUT$NEXT"
        fi
        printf "\r\033[K\b${sp:i%${#sp}:1} [%d/%d](%3.2f)%% |  No. of high GC: %d" "$END" "$LEN" $(($END / $LEN * 100)) "$COUNT"
    done
    OUTPUT="$(grep '>' chr22.fa)""$(echo $OUTPUT | fold -w $LIMIT)"
    echo "$OUTPUT" >chr22.masked.fa

}

main 100
