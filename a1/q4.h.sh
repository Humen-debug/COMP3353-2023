#!/bin/bash
PATTERN="(C|c|G|g)+[C|c|G|g]"
grep -oE "$PATTERN" chr22.fa | sort -n | tail -1
