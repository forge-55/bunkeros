#!/usr/bin/env bash

file="$1"
w="$2"
h="$3"
x="$4"
y="$5"

if [ ! -f "$file" ]; then
    echo "Not a file"
    exit 1
fi

mime_type=$(file --mime-type -b "$file")

case "$mime_type" in
    text/*)
        bat --color=always --style=plain --pager=never "$file" 2>/dev/null || cat "$file"
        ;;
    application/json)
        jq -C . "$file" 2>/dev/null || cat "$file"
        ;;
    application/pdf)
        pdftotext "$file" - 2>/dev/null || echo "PDF preview requires pdftotext"
        ;;
    image/*)
        chafa --fill=block --symbols=block -c 256 -s "${w}x${h}" "$file" 2>/dev/null || echo "Image: $file"
        ;;
    application/gzip|application/x-tar|application/x-bzip2|application/x-xz|application/zip)
        tar -tzf "$file" 2>/dev/null || unzip -l "$file" 2>/dev/null || echo "Archive: $file"
        ;;
    video/*|audio/*)
        mediainfo "$file" 2>/dev/null || echo "Media file: $file"
        ;;
    *)
        echo "Binary file: $file"
        file -b "$file"
        ;;
esac

