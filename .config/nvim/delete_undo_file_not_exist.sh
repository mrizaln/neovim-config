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
while read file; do
    real_file="${file//%//}"
    
    if [ ! -f "$real_file" ]; then
        rm "$file"
        count=$((count + 1))
    fi
done < <(ls -1)

echo "Info: done"
echo "Summary: deleted ${count} files"
