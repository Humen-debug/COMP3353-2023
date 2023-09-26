#!/bin/bash
FILE=./q2_output.txt
if ! test -f "$FILE"; then
    python ./generator.py "$FILE" $((1000 ** 10))
    echo "Complete RNA generation."
fi
rnaCodenMapper() {
    rna=$1 # take 3-charater string as input

    # check if the rna has length of 3
    if [[ ${#rna} -ne 3 ]]; then
        echo "ERROR: invalid length. ${#rna}"
    fi
    # change input string to uppercase
    rna=$(echo $rna | tr '[:lower:]' '[:upper:]')
    case $rna in
    UUC | UUU) echo "F" ;;
    UUA | UUG | CUU | CUC | CUA | CUG) echo "L" ;;
    UCU | UCC | UCA | UCG | AGC | AGU) echo "S" ;;
    UAU | UAC) echo "Y" ;;
    UAA | UAG | UGA) echo "" ;;
    UGU | UGC) echo "C" ;;
    UGG) echo "W" ;;
    CCU | CCC | CCA | CCG) echo "P" ;;
    CAU | CAC) echo "H" ;;
    CAG | CAA) echo "Q" ;;
    CGU | CUC | CUA | CUG) echo "R" ;;
    AUA | AUC | AUU) echo "I" ;;
    AUG) echo "M" ;;
    ACU | ACC | ACA | ACG) echo "T" ;;
    AAC | AAU) echo "N" ;;
    AAG | AAA) echo "K" ;;
    AGA | AGG) echo "R" ;;
    GUU | GUG | GUA | GUC) echo "V" ;;
    GCU | GCG | GCA | GCG) echo "A" ;;
    GAU | GAC) echo "D" ;;
    GAA | GAG) echo "E" ;;
    GGU | GGC | GGA | GGG) echo "G" ;;
    *) echo "ERROR: Not founded ($rna)" ;;
    esac
}

main() {
    rna=$1
    i=1
    res=""
    while [[ $(($i + 3)) -le ${#rna} ]]; do
        substring=$(echo $rna | cut -c $i-$(($i + 2)))
        coden=$(rnaCodenMapper $substring)

        if [[ "$coden" == "" ]]; then
            break
        fi
        res=$res$coden
        i=$(expr $i + 3)
    done

    echo $res
}

INPUT=$(<"$FILE")
main $INPUT
