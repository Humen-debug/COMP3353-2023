#!/bin/bash
PATTERN="[C|c][A|a][G|g]"
grep -oE "($PATTERN)+" chr22.fa | sort | tail -1
