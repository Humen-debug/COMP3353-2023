#!/bin/bash
STR="ATTCCGAATCAGGGT"
MUT="[A|T|C|G]"
patternGenerator() {
    len=${#STR}
    RES=""
    for ((i = 0; i < $len; i++)); do
        HEAD=""
        if [[ $i != 0 ]]; then
            HEAD=$(echo "$STR" | cut -c -$i)
        fi
        MID=$(($i + 2))

        TAIL=$(echo $STR | cut -c$MID-$len)
        if [[ $i = 0 ]]; then
            RES="$HEAD$MUT$TAIL"
        else
            RES="$RES|$HEAD$MUT$TAIL"
        fi
    done

    echo "$RES"
}

PATTERN=$(patternGenerator)
grep -v ">" chr22.fa | tr -d "\s\r,\n,\t,\r\n,\r" | grep -oE "$PATTERN"
