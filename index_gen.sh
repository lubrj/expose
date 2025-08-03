#!/bin/bash
> index.md

dir_count=0
file_count=0
total_size=0

f() {
  local d="$1" p="$2"
  ((dir_count++))
  mapfile -d '' entries < <(find "$d" -mindepth 1 -maxdepth 1 -print0 | sort -z)
  for i in "${entries[@]}"; do
    if [ -d "$i" ]; then
      echo "$p- **$(basename "$i")/**" >> index.md
      f "$i" "  $p"
    elif [ -f "$i" ]; then
      echo "$p- $(basename "$i")" >> index.md
      ((file_count++))
      size=$(stat -c%s "$i")
      ((total_size+=size))
    fi
  done
}

f "${1:-.}" ""

{
  echo "# Data Summary"
  echo ""
  echo "## Total directories: $dir_count"
  echo "## Total files: $file_count"
  echo "## Total size: $((total_size / 1024)) KB"
  echo ""
  cat index.md
} > tmp.md && mv tmp.md index.md

