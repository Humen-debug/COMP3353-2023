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

sp="/-\|"

calcGC() {
    K=$1
    INPUT=$2
    COUNT=0
    LEN=${#INPUT}
    N=$(ceil $(echo "scale=0; $K*0.7" | bc -l))
    for ((i = 1; i <= $LEN - $K; i++)); do
        SUB=${INPUT:0:K}
        flag=$(isHighGC $(($N + 1)) $SUB)
        if [[ $flag -gt 0 ]]; then
            ((COUNT++))
        fi
    done
    echo $COUNT
}

# NOTE:
# 1. Split the string into 200 chunks (in chr22.fa each chunk should have 254092 characters/bytes)
# 2. Parallel process each chunk to count the high-gc content
# 3. Pair-up each chunks to get those "in-between" substrings
main() {
    K=$1
    COUNT=0
    INPUT=$(grep -v ">" chr22.fa | tr -d "\s\r,\n,\t,\r\n,\r")
    LEN=${#INPUT}
    # Step 1: find size of each chunk
    SIZE=$(echo "scale=0; $LEN/200" | bc -l)

    CHUNKS=$(echo "$INPUT" | fold -w $SIZE)

    # Parallel process for counting gc content of each chunk
    i=0
    while IFS= read -r line; do
        ((i++))
        calcGC $K "$line" >"./q5.a/res.$i.txt" &
    done < <(echo "$CHUNKS")

    wait

    echo $COUNT
}

main 100
