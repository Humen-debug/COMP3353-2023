#!/bin/bash
cat chr22.fa | tr [a-z] [A-Z] | grep -oE "A[A|T|C|G]GCTT" | wc -l
