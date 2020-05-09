#!/bin/sh

echo "# Index" > index.md

for file in $(find articles -name "*.md")
do
    name=$(echo "$file" | awk -F "/" '{print $NF}' | sed 's/\.md//g')
    echo "[$name]($file)" >> index.md
done


