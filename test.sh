#!/usr/bin/env bash
# test.sh - Test suite for revcomp.sh

SCRIPT="$(dirname "$0")/revcomp.sh"
PASS=0
FAIL=0

run_test() {
    local description="$1"
    local expected="$2"
    local actual="$3"

    if [[ "$actual" == "$expected" ]]; then
        echo "  PASS: $description"
        ((PASS++))
    else
        echo "  FAIL: $description"
        echo "    Expected : |$expected|"
        echo "    Got      : |$actual|"
        ((FAIL++))
    fi
}

cat > /tmp/test_basic.fa <<'EOF'
>seq1
ATCGATCG
>seq2
AAACCCGGGTTT
EOF

cat > /tmp/test_multiline.fa <<'EOF'
>multiline_seq
ATCG
TTAA
GCGC
EOF

cat > /tmp/test_single.fa <<'EOF'
>single
A
EOF

cat > /tmp/test_allbases.fa <<'EOF'
>allbases
AACCGGTT
EOF

cat > /tmp/test_lowercase.fa <<'EOF'
>lc
atcg
EOF

echo "========================================"
echo " revcomp.sh Test Suite"
echo "========================================"

echo ""
echo "Test 1: Basic two-sequence file (file argument)"
ACTUAL=$(bash "$SCRIPT" /tmp/test_basic.fa)
EXPECTED=$(printf '>seq1\nCGATCGAT\n>seq2\nAAACCCGGGTTT')
run_test "basic file: full output matches" "$EXPECTED" "$ACTUAL"

echo ""
echo "Test 2: Reading from stdin"
ACTUAL=$(cat /tmp/test_basic.fa | bash "$SCRIPT")
run_test "stdin: full output matches" "$EXPECTED" "$ACTUAL"

echo ""
echo "Test 3: Multi-line FASTA sequence"
ACTUAL=$(bash "$SCRIPT" /tmp/test_multiline.fa)
ACTUAL_SEQ=$(echo "$ACTUAL" | grep -v '^>')
run_test "multi-line: joined, reversed, complemented" "GCGCTTAACGAT" "$ACTUAL_SEQ"

echo ""
echo "Test 4: Single-base sequence"
ACTUAL=$(bash "$SCRIPT" /tmp/test_single.fa | grep -v '^>')
run_test "single base: A → T" "T" "$ACTUAL"

echo ""
echo "Test 5: Palindromic sequence (AACCGGTT)"
ACTUAL=$(bash "$SCRIPT" /tmp/test_allbases.fa | grep -v '^>')
run_test "palindrome: AACCGGTT → AACCGGTT" "AACCGGTT" "$ACTUAL"

echo ""
echo "Test 6: FASTA headers preserved"
ACTUAL_HEADERS=$(bash "$SCRIPT" /tmp/test_basic.fa | grep '^>')
EXPECTED_HEADERS=$(printf '>seq1\n>seq2')
run_test "headers preserved" "$EXPECTED_HEADERS" "$ACTUAL_HEADERS"

echo ""
echo "Test 7: Error handling — missing file"
if bash "$SCRIPT" /tmp/no_such_file_xyz.fa 2>/dev/null; then
    echo "  FAIL: Should exit non-zero for missing file"
    ((FAIL++))
else
    echo "  PASS: Non-existent file causes non-zero exit"
    ((PASS++))
fi
ERR_MSG=$(bash "$SCRIPT" /tmp/no_such_file_xyz.fa 2>&1 >/dev/null || true)
run_test "error message sent to stderr" "1" "$([ -n "$ERR_MSG" ] && echo 1 || echo 0)"

echo ""
echo "Test 8: Error handling — too many arguments"
if bash "$SCRIPT" /tmp/test_basic.fa extra_arg 2>/dev/null; then
    echo "  FAIL: Should exit non-zero for too many arguments"
    ((FAIL++))
else
    echo "  PASS: Too many arguments causes non-zero exit"
    ((PASS++))
fi

echo ""
echo "Test 9: Lowercase bases"
ACTUAL=$(bash "$SCRIPT" /tmp/test_lowercase.fa | grep -v '^>')
run_test "lowercase: atcg → cgat" "cgat" "$ACTUAL"

echo ""
echo "========================================"
echo " Results: $PASS passed, $FAIL failed"
echo "========================================"
echo ""

[[ $FAIL -eq 0 ]]
