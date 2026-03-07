#!/usr/bin/env bash
# revcomp.sh - Reverse Complement Generator
# Reads FASTA sequences from a file or stdin and prints the reverse complement

set -euo pipefail

usage() {
    echo "Usage: $0 [fasta_file]" >&2
    echo "  If no file is given, reads FASTA input from stdin." >&2
    exit 1
}

if [[ $# -gt 1 ]]; then
    echo "Error: Too many arguments." >&2
    usage
fi

if [[ $# -eq 1 ]]; then
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' does not exist." >&2
        exit 1
    fi
    INPUT="$1"
else
    INPUT="/dev/stdin"
fi

# Function: compute reverse complement of a DNA string
# Step 1: rev reverses the string character by character
# Step 2: tr swaps each base for its complement (A<->T, C<->G)

reverse_complement() {
    local seq="$1"
    echo "$seq" \
        | rev \
        | tr 'ACGTacgt' 'TGCAtgca'
}

current_header=""
current_seq=""

process_record() {
    if [[ -n "$current_header" ]]; then
        echo "$current_header"
        reverse_complement "$current_seq"
    fi
}

# Read through the input line by line
# Accumulate sequence lines until we hit a new header or end of file

while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line//$'\r'/}"
    if [[ "$line" == ">"* ]]; then
        process_record
        current_header="$line"
        current_seq=""
    else
        current_seq="${current_seq}${line}"
    fi
done < "${INPUT}"

process_record
