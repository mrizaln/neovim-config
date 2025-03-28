#!/usr/bin/env bash

undodir=~/.local/state/nvim/undo        # check your undodir path, might be different
echo "Info: undodir = '${undodir}'"

if [ ! -d "$undodir" ]; then
    echo "undodir does not exist, exiting"
    exit 1
elif [ -z "$(ls -A $undodir)" ]; then
    echo "undodir is empty, exiting"
    exit 1
fi

echo "Info: deleting undo files of nonexistent files in '${undodir}' ..."
cd "$undodir"

count=0
total_size=0

while read file; do
    real_file="${file//%//}"

    if [ ! -f "$real_file" ]; then
        current_size=$(stat --printf %s "$file")
        total_size=$((total_size + current_size))
        count=$((count + 1))
        rm "$file"
    fi
done < <(ls -1)

echo "Info: done"
echo "Summary: deleted ${count} files (amounting to $(numfmt --to=iec-i --suffix=B $total_size))"
