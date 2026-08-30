#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture_root="$(mktemp -d /tmp/rsr-invisible-test.XXXXXX)"
cleanup() {
  case "$fixture_root" in
    /tmp/rsr-invisible-test.*) rm -rf -- "$fixture_root" ;;
    *) echo "refusing unsafe cleanup target: $fixture_root" >&2 ;;
  esac
}
trap cleanup EXIT

scanner="$repo_root/scripts/check-invisible-characters.sh"
results="$fixture_root/results.bin"
fixtures="$fixture_root/fixtures"
mkdir -p "$fixtures"

printf 'tab\tline\ncarriage\rreturn\n' > "$fixtures/safe.md"
printf 'nbsp:\302\240\n' > "$fixtures/nbsp.md"
printf 'soft-hyphen:\302\255\n' > "$fixtures/soft-hyphen.adoc"
printf 'zero-width:\342\200\213\n' > "$fixtures/zero-width.json"
printf 'bidi:\342\200\256\n' > "$fixtures/bidi.toml"
printf 'word-joiner:\342\201\240\n' > "$fixtures/word-joiner.yml"
printf '\357\273\277leading bom\n' > "$fixtures/bom.sh"
printf 'nul:\000byte\n' > "$fixtures/nul.rs"
printf 'invalid:\377 then nbsp:\302\240\n' > "$fixtures/invalid-utf8.md"
printf 'newline name:\302\240\n' > "$fixtures/with
newline.md"

"$scanner" "$fixtures" "$results"

count=0
safe_seen=false
newline_seen=false
while IFS= read -r -d '' filepath; do
  count=$((count + 1))
  [[ "$filepath" == "$fixtures/safe.md" ]] && safe_seen=true
  [[ "$filepath" == "$fixtures/with"$'\n'"newline.md" ]] && newline_seen=true
done < "$results"

[[ "$count" -eq 9 ]] || {
  echo "expected 9 findings, got $count" >&2
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

echo "invisible-character scanner positive and negative controls passed"
