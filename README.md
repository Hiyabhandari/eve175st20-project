# Reverse Complement Generator

A bash script that reads DNA sequences in FASTA format and outputs their reverse complements.

## What It Does

Given a FASTA file, revcomp.sh computes the reverse complement of each sequence
and prints the result in FASTA format. Headers are preserved unchanged.

Reverse complement means:
1. Reverse the sequence string
2. Complement each base: A<->T, C<->G

## Usage

  From a file:
  ./revcomp.sh input.fa

  From stdin:
  cat input.fa | ./revcomp.sh

## Input Format

Standard FASTA format:
  >sequence_header
  ATCGATCG

  - Header lines begin with >
  - Sequences may span multiple lines
  - Uppercase and lowercase bases are both handled

## Output Format

  >sequence_header
  CGATCGAT

## Example

  Input (input.fa):
  >seq1
  ATCGATCG
  >seq2
  AAACCCGGGTTT

  Run:
  ./revcomp.sh input.fa

  Output:
  >seq1
  CGATCGAT
  >seq2
  AAACCCGGGTTT

## Error Handling

  - File does not exist: prints error to stderr, exits with code 1
  - Too many arguments: prints usage info, exits with code 1
  - No argument given: reads from stdin

## Running the Tests

  chmod +x revcomp.sh test.sh
  ./test.sh

## Dependencies

  - bash (v4+)
  - rev, tr: standard Unix tools, no install needed

## Files

  revcomp.sh   Main script
  test.sh      Automated test suite
  input.fa     Sample input file
  README.md    This file
