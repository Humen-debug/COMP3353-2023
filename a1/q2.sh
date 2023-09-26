#!/bin/bash
FILE=./DNA.txt
if ! test -f "$FILE"; then
    python ./generator.py DNA.txt
    echo "Complete DNA generation."
fi
INPUT=$(<"$FILE")
echo "$INPUT" | tr 'ATCGatcg' 'UAGCuagc' >"./q2_output.txt"
