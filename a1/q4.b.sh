#!/bin/bash
HINDIII="AAGCTT"
cat chr22.fa | tr [a-z] [A-Z] | grep -o "$HINDIII" | wc -l
