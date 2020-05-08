#!/bin/sh

echo "# Index" > index.md

for dir in ./articles/*/
do
    echo "${dir}" | awk -F\/ '{printf "\n## %s\n\n", $3}' >> index.md
    for file in ${dir}*.md
    do
        echo "[${file}](${file})" >> index.md
    done
done

