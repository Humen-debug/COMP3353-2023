# remove the first line and delete all newlines in chr22.fa.
# Sperate A with AGCTT by regex and separate the input by pattern.

ARR=$(grep -v ">" chr22.fa | tr [a-z] [A-Z] | sed 's/AAGCTT/A\'$'\nAGCTT/g' | tr -d "\n")
COUNT=1
for i in "${ARR[@]}"; do
    printf "fragment %d with length %d\n" "$COUNT" "${#i}"
    ((COUNT++))
done
