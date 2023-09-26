#!/bin/bash
FILE=./DNA.txt
if ! test -f "$FILE"; then
    python ./generator.py DNA.txt
    echo "Complete DNA generation."
fi
INPUT=$(<"$FILE")
# takes the input, then reverse the symbols by `rev`.
# finally tranverse the symbols by A->T. T->A, C->G, and G->C
echo "$INPUT" | rev | tr 'ATCGatcg' 'TAGCtagc' >"./q1_output.txt"
