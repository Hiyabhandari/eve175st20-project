# Reverse Complement Generator

A bash script that reads DNA sequences in FASTA format and outputs their reverse complements.

---

## What It Does

Given a FASTA file, revcomp.sh computes the reverse complement of each sequence
and prints the result in FASTA format. Headers are preserved unchanged.

Reverse complement means:
1. Reverse the sequence string
2. Complement each base: A<->T, C<->G

Example:
    Original:    ATCGATCG
    Reversed:    GCTAGCTA
    Complement:  CGATCGAT  <- final answer

The script uses two Unix commands:
    rev  -> reverses the string character by character
    tr   -> swaps each base for its complement (A->T, T->A, C->G, G->C)

---

## Why Is This Useful?

- Designing PCR primers (one primer always targets the reverse complement strand)
- Finding genes on the opposite strand of DNA
- Analyzing sequencing data
- Any bioinformatics pipeline working with double-stranded DNA

---

## Files

  revcomp.sh   Main script
  test.sh      Automated test suite
  input.fa     Sample input file
  README.md    This file
  
## Usage

    # From a file
    ./revcomp.sh input.fa

    # From stdin (pipe)
    cat input.fa | ./revcomp.sh

    # Pipe a single sequence directly
    echo ">myseq
    ATCGATCG" | ./revcomp.sh

---

## Input Format

Standard FASTA format:

    >sequence_header
    ATCGATCG

    - Header lines begin with >
    - Sequences may span multiple lines
    - Uppercase and lowercase bases are both handled

---

## Output Format

    >sequence_header
    CGATCGAT

    - Same headers as input, unchanged
    - Sequence is the reverse complement of the input

---

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

Note: seq2 is a palindrome so its reverse complement is itself.

---

## How It Works Step by Step

1. The script opens the FASTA file (or reads from stdin)
2. It reads through the file line by line
3. When it sees a > header line it saves the header
4. When it sees sequence lines it collects them all together
5. When it hits the next header or end of file it computes
   the reverse complement of the full collected sequence
6. It prints the header unchanged and the reverse complemented sequence below
7. Repeats for every sequence in the file

This approach correctly handles multi-line FASTA sequences where one
sequence is split across many lines.

---

## All Commands — Copy Paste Reference

Run on a file:

    ./revcomp.sh input.fa

Run using stdin:

    echo ">myseq
    ATCGATCG" | ./revcomp.sh

Run on your own file:

    ./revcomp.sh yourfile.fa

Run the test suite:

    bash test.sh

Expected test output:

    Results: 10 passed, 0 failed

Error — missing file:

    ./revcomp.sh fakefile.fa
    Error: File 'fakefile.fa' does not exist.

Error — too many arguments:

    ./revcomp.sh file1.fa file2.fa
    Error: Too many arguments.

---

## Error Handling

    - File does not exist : prints error to stderr, exits with code 1
    - Too many arguments  : prints usage info, exits with code 1
    - No argu# Reverse Complement Generator


## AI Assistance

This project was developed with assistance from Claude (Anthropic AI).

AI was used to help with:
- Writing the test cases in test.sh
- Formatting the README

All code has been reviewed, tested, and understood by the author.
The reverse complement logic, FASTA parsing approach, and error
handling were explained and verified line by line.
