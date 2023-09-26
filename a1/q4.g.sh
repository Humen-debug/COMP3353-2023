#!/bin/bash
# Notes
# 1. Only the consequective Ns at the very beginning and the very end are not counted as gap.
# 2. Consequective Ns are counted as ONE gap

# Grep lines with consequective Ns, then concat the lines by removing newline char.
# Replace genome other than N with whitespaces and remove duplicated whitespaces.
# Replace the whitespaces with newline so that we can count the gaps by newline.
TOTAL=$(egrep "[^N|^n]*(N|n)" chr22.fa | tr -d "\s\r,\n,\t,\r\n,\r" | sed 's/[atcgATCG]/ /g' | tr -s ' ' | tr ' ' '\n' | wc -l)

# Substract the very beginning and very end
echo $(($TOTAL - 2))
