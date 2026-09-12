#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# Scanner for invisible Unicode codepoints and forbidden C0 control bytes.
set -u

scan_root="${1:-}"
results_file="${2:-}"
blocking_results_file="${3:-}"
grep_bin="${INVISIBLE_GREP_BIN:-grep}"
find_bin="${INVISIBLE_FIND_BIN:-find}"
od_bin="${INVISIBLE_OD_BIN:-od}"

if [[ -z "$scan_root" || ! -d "$scan_root" || -z "$results_file" ]]; then
  echo "usage: $0 SCAN_ROOT RESULTS_FILE" >&2
  exit 2
fi

# grep -P matches Unicode characters, so multi-byte UTF-8 encodings must be
# expressed as codepoints. The C0 class deliberately excludes TAB, LF, and CR.
pattern='[\x00-\x08\x0B\x0C\x0E-\x1F]|\x{a0}|\x{ad}|[\x{200b}-\x{200f}]|[\x{202a}-\x{202f}]|\x{2060}|[\x{2066}-\x{2069}]|\x{feff}'
blocking_pattern='[\x00-\x08\x0B\x0C\x0E-\x1F]'
: > "$results_file" || exit 2
if [[ -n "$blocking_results_file" ]]; then
  : > "$blocking_results_file" || exit 2
fi
scan_error=0
enumeration_file="$(mktemp /tmp/rsr-invisible-files.XXXXXX)" || exit 2
# Invoked indirectly by the EXIT trap.
# cleanup removes the temporary file used for file enumeration.
cleanup() {
  rm -f -- "$enumeration_file"
}
trap cleanup EXIT

if ! "$find_bin" "$scan_root" \
    -not -path '*/.git/*' -not -path '*/node_modules/*' \
    -not -path '*/.deno/*' -not -path '*/target/*' \
    -not -path '*/_build/*' -not -path '*/deps/*' \
    -not -path '*/external_corpora/*' -not -path '*/.lake/*' \
    -type f \( -name '*.rs' -o -name '*.ex' -o -name '*.exs' -o -name '*.res' \
      -o -name '*.js' -o -name '*.ts' -o -name '*.json' -o -name '*.toml' \
      -o -name '*.yml' -o -name '*.yaml' -o -name '*.md' -o -name '*.adoc' \
      -o -name '*.idr' -o -name '*.zig' -o -name '*.v' -o -name '*.jl' \
      -o -name '*.gleam' -o -name '*.hs' -o -name '*.ml' -o -name '*.sh' \) \
    -print0 > "$enumeration_file"; then
  echo "file enumeration failed: $scan_root" >&2
  exit 1
fi

while IFS= read -r -d '' filepath; do
  matched=false

  LC_ALL=C.UTF-8 "$grep_bin" -aPq "$pattern" "$filepath"
  unicode_status=$?
  case "$unicode_status" in
    0) matched=true ;;
    1) ;;
    *) echo "scanner error ($unicode_status): $filepath" >&2; scan_error=1 ;;
  esac

  # Check the first three bytes independently. This keeps leading-BOM
  # detection explicit instead of relying on Unicode matching behaviour.
  leading_bytes="$(LC_ALL=C "$od_bin" -An -tx1 -N3 -- "$filepath" 2>/dev/null)"
  byte_status=$?
  if [[ "$byte_status" -ne 0 ]]; then
    echo "leading-BOM scanner error ($byte_status): $filepath" >&2
    scan_error=1
  else
    leading_bytes="${leading_bytes//[[:space:]]/}"
    [[ "$leading_bytes" == "efbbbf" ]] && matched=true
  fi

  if [[ "$matched" == true ]]; then
    printf '%s\0' "$filepath" >> "$results_file" || scan_error=1
    if [[ -n "$blocking_results_file" ]]; then
      LC_ALL=C.UTF-8 "$grep_bin" -aPq "$blocking_pattern" "$filepath"
      blocking_status=$?
      case "$blocking_status" in
        0) printf '%s\0' "$filepath" >> "$blocking_results_file" || scan_error=1 ;;
        1) ;;
        *) echo "blocking-classifier error ($blocking_status): $filepath" >&2; scan_error=1 ;;
      esac
    fi
  fi
done < "$enumeration_file"

exit "$scan_error"
