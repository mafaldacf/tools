#!/usr/bin/env bash
#
# rename-recursive.sh - Recursively rename files and folders by replacing text in their names.
#
# Usage:
#   rename-recursive.sh [-n] <directory> <from> <to>
#
# Options:
#   -n    Dry run: show what would be renamed without changing anything
#   -h    Show this help
#
# Example:
#   rename-recursive.sh output attack defend
#   rename-recursive.sh -n output attack defend   # preview only

set -euo pipefail

usage() {
  sed -n '3,14p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

dry_run=false
while getopts ":nh" opt; do
  case "$opt" in
    n) dry_run=true ;;
    h) usage 0 ;;
    *) echo "Unknown option: -$OPTARG" >&2; usage 1 ;;
  esac
done
shift $((OPTIND - 1))

[[ $# -eq 3 ]] || { echo "Error: expected 3 arguments, got $#." >&2; usage 1; }

dir=$1
from=$2
to=$3

[[ -d $dir ]]    || { echo "Error: '$dir' is not a directory." >&2; exit 1; }
[[ -n $from ]]   || { echo "Error: <from> cannot be empty." >&2; exit 1; }
[[ $to != */* ]] || { echo "Error: <to> cannot contain '/'." >&2; exit 1; }

count=0
skipped=0

# -depth: process a folder's contents before the folder itself, so paths stay valid.
# -mindepth 1: never rename the top-level directory you passed in.
while IFS= read -r -d '' path; do
  base=${path##*/}
  parent=${path%/*}

  [[ $base == *"$from"* ]] || continue

  new_base=${base//"$from"/"$to"}
  new_path="$parent/$new_base"

  if [[ -e $new_path ]]; then
    echo "Skipped (target exists): $path -> $new_path" >&2
    skipped=$((skipped + 1))
    continue
  fi

  if $dry_run; then
    echo "Would rename: $path -> $new_path"
  else
    mv -- "$path" "$new_path"
    echo "Renamed: $path -> $new_path"
  fi
  count=$((count + 1))
done < <(find "$dir" -mindepth 1 -depth -print0)

if $dry_run; then
  echo "Dry run complete: $count item(s) would be renamed, $skipped skipped."
else
  echo "Done: $count item(s) renamed, $skipped skipped."
fi
