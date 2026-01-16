#!/bin/bash

# This script finds all index.md files in the current directory and its
# subdirectories, and then uses Pandoc to convert them to clean
# HTML files with a name based on the title.

# Stop on error
set -e

# Find all index.md files
find . -name "index.md" | while read -r md_file; do
  echo "Processing $md_file"

  # The directory where the file is located
  dir=$(dirname "$md_file")

  # Extract title from the markdown file
  title=$(grep -m 1 "title:" "$md_file" | sed 's/title: //' | sed 's/^[ \t]*//;s/[ \t]*$//')

  # If title is empty, use the directory name as a fallback
  if [ -z "$title" ]; then
    title=$(basename "$dir")
  fi

  # Convert title to snake_case
  snake_case_title=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '_' | sed 's/[^a-z0-9_]//g')

  # The name of the final html file
  html_file="$dir/$snake_case_title.html"

  # Convert the Markdown file to a clean HTML file using Pandoc
  pandoc "$md_file" -s -o "$html_file" --css=../elements_of.css --toc --syntax-highlighting=pygments --include-after-body analytics.html --filter mermaid-filter

  echo "Successfully converted $md_file to $html_file"
done

echo "All files converted."