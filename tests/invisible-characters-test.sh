#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture_root="$(mktemp -d /tmp/rsr-invisible-test.XXXXXX)"
# cleanup removes the temporary test fixture directory when its path matches the expected location and reports unsafe paths without removing them.
cleanup() {
  case "$fixture_root" in
    /tmp/rsr-invisible-test.*) rm -rf -- "$fixture_root" ;;
    *) echo "refusing unsafe cleanup target: $fixture_root" >&2 ;;
  esac
}
trap cleanup EXIT

scanner="$repo_root/scripts/check-invisible-characters.sh"
results="$fixture_root/results.bin"
blocking_results="$fixture_root/blocking-results.bin"
fixtures="$fixture_root/fixtures"
mkdir -p "$fixtures"

# Guard the implementation contract as well as its observable matches: grep -P
# must receive Unicode codepoints, never their constituent UTF-8 bytes.
for escape in '\x{a0}' '\x{ad}' '\x{200b}' '\x{202a}' '\x{2060}' '\x{2066}' '\x{feff}'; do
  grep -Fq -- "$escape" "$scanner" || {
    echo "scanner is missing required codepoint escape: $escape" >&2
    exit 1
  }
done
for legacy_byte in '\xC2' '\xE2' '\xEF'; do
  if grep -Fq -- "$legacy_byte" "$scanner"; then
    echo "scanner still contains UTF-8 byte-sequence patterns: $legacy_byte" >&2
    exit 1
  fi
done
grep -Fq -- '[\x00-\x08\x0B\x0C\x0E-\x1F]' "$scanner" || {
  echo "scanner C0 range no longer excludes only TAB, LF, and CR" >&2
  exit 1
}

printf 'tab\tline\ncarriage\rreturn\n' > "$fixtures/safe.md"
printf 'nbsp:\302\240\n' > "$fixtures/nbsp.md"
printf 'soft-hyphen:\302\255\n' > "$fixtures/soft-hyphen.adoc"
printf 'zero-width:\342\200\213\n' > "$fixtures/zero-width.json"
printf 'bidi:\342\200\256\n' > "$fixtures/bidi.toml"
printf 'word-joiner:\342\201\240\n' > "$fixtures/word-joiner.yml"
printf '\357\273\277leading bom\n' > "$fixtures/bom.sh"
printf 'mid-file \357\273\277 bom\n' > "$fixtures/mid-bom.sh"
printf 'nul:\000byte\n' > "$fixtures/nul.rs"
printf 'backspace:\010byte\n' > "$fixtures/backspace.rs"
printf 'invalid:\377 then nbsp:\302\240\n' > "$fixtures/invalid-utf8.md"
printf 'newline name:\302\240\n' > "$fixtures/with
newline.md"

"$scanner" "$fixtures" "$results" "$blocking_results"

count=0
safe_seen=false
newline_seen=false
while IFS= read -r -d '' filepath; do
  count=$((count + 1))
  [[ "$filepath" == "$fixtures/safe.md" ]] && safe_seen=true
  [[ "$filepath" == "$fixtures/with"$'\n'"newline.md" ]] && newline_seen=true
done < "$results"

[[ "$count" -eq 11 ]] || {
  echo "expected 11 findings, got $count" >&2
  exit 1
}
[[ "$safe_seen" == false ]] || {
  echo "TAB/LF/CR-only safe fixture was incorrectly reported" >&2
  exit 1
}
[[ "$newline_seen" == true ]] || {
  echo "newline-containing filename was not preserved as one record" >&2
  exit 1
}

blocking_count=0
nul_blocked=false
backspace_blocked=false
while IFS= read -r -d '' filepath; do
  blocking_count=$((blocking_count + 1))
  [[ "$filepath" == "$fixtures/nul.rs" ]] && nul_blocked=true
  [[ "$filepath" == "$fixtures/backspace.rs" ]] && backspace_blocked=true
done < "$blocking_results"
[[ "$blocking_count" -eq 2 && "$nul_blocked" == true && "$backspace_blocked" == true ]] || {
  echo "expected only NUL and backspace fixtures in the blocking set" >&2
  exit 1
}

# Prove the byte-wise leading-BOM path works even when Unicode matching reports
# no match. The mid-file BOM remains the codepoint scanner's responsibility.
bom_only_fixtures="$fixture_root/bom-only-fixtures"
mkdir -p "$bom_only_fixtures"
printf '\357\273\277leading bom\n' > "$bom_only_fixtures/leading-bom.sh"
printf 'mid-file \357\273\277 bom\n' > "$bom_only_fixtures/mid-bom.sh"
no_match_grep="$fixture_root/no-match-grep"
printf '#!/usr/bin/env sh\nexit 1\n' > "$no_match_grep"
chmod +x "$no_match_grep"
INVISIBLE_GREP_BIN="$no_match_grep" \
  "$scanner" "$bom_only_fixtures" "$results" "$blocking_results"

bom_count=0
leading_bom_seen=false
mid_bom_seen=false
while IFS= read -r -d '' filepath; do
  bom_count=$((bom_count + 1))
  [[ "$filepath" == "$bom_only_fixtures/leading-bom.sh" ]] && leading_bom_seen=true
  [[ "$filepath" == "$bom_only_fixtures/mid-bom.sh" ]] && mid_bom_seen=true
done < "$results"
[[ "$bom_count" -eq 1 && "$leading_bom_seen" == true && "$mid_bom_seen" == false ]] || {
  echo "leading-BOM byte scan was not independent of Unicode matching" >&2
  exit 1
}

if "$scanner" "$fixture_root/missing" "$results"; then
  echo "missing scan root did not fail closed" >&2
  exit 1
fi

failing_grep="$fixture_root/failing-grep"
printf '#!/usr/bin/env sh\nexit 2\n' > "$failing_grep"
chmod +x "$failing_grep"
if INVISIBLE_GREP_BIN="$failing_grep" "$scanner" "$fixtures" "$results"; then
  echo "grep execution errors did not fail closed" >&2
  exit 1
fi

failing_find="$fixture_root/failing-find"
printf '#!/usr/bin/env sh\nexit 2\n' > "$failing_find"
chmod +x "$failing_find"
if INVISIBLE_FIND_BIN="$failing_find" "$scanner" "$fixtures" "$results"; then
  echo "find execution errors did not fail closed" >&2
  exit 1
fi

failing_od="$fixture_root/failing-od"
printf '#!/usr/bin/env sh\nexit 2\n' > "$failing_od"
chmod +x "$failing_od"
if INVISIBLE_OD_BIN="$failing_od" "$scanner" "$fixtures" "$results"; then
  echo "leading-BOM scanner errors did not fail closed" >&2
  exit 1
fi

echo "invisible-character scanner positive and negative controls passed"
