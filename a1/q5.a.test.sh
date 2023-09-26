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
    N=$(ceil $(echo "scale=0; $K*0.7" | bc -l))
    # frequently used command
    CMD="grep -v '>' chr22.fa | grep -vE '^[N|n]+\b.*$'"
    # Remove lines that are spanned by N (they are definitely not high GC content)
    INPUT=$(eval "$CMD" | tr -d "\s\r,\n,\t,\r\n,\r")
    ## INPUT=$(grep -v ">" chr22.fa | grep -vE "^[N|n]+\b.*$" | sed -n "50000,50100p" | tr -d "\s\r,\n,\t,\r\n,\r")

    # Number of lines in files
    LINES=$(eval "$CMD" | wc -l)

    # original length of string per newline. It is used to reunion the file in format of fasta.
    LIMIT=$(grep -v '>' chr22.fa | head -n 1 | tr -d "\n" | wc -c)

    # length of concatted strings
    LEN=${#INPUT}

    while [[ $(($i + $K)) -le $LEN ]]; do
        END=$(($i + $K - 1))
        SUB=$(echo "$INPUT" | cut -c $i-$END)
        printf "\r\033[K\b${sp:i%${#sp}:1} [%d/%d](%3.2f)%% | No. of high GC: %d" "$END" "$LEN" $(($END / $LEN * 100)) "$COUNT"
        flag=$(isHighGC $(($N + 1)) $SUB)
        if [[ $flag -gt 0 ]]; then
            COUNT=$(($COUNT + 1))
        fi
        ((i++))
    done
    echo $COUNT
}

main 100
