#!/bin/bash

# This script finds all index.md.html files in the current directory and its
# subdirectories, extracts the Markdown content and metadata, formats it with
# a YAML front matter block, and then uses Pandoc to convert them to clean
# HTML files with a name based on the title.

# Stop on error
set -e

# Find all index.md.html files
find . -name "index.md.html" | while read -r file; do
  echo "Processing $file"

  # The directory where the file is located
  dir=$(dirname "$file")

  # The name of the markdown file
  md_file="$dir/index.md"

  # Extract metadata and content using awk
  awk '
    BEGIN {
      in_header = 1
    }
    {
      if (in_header) {
        if ($0 ~ /<meta charset="utf-8">/) {
          next
        }
        if ($0 ~ /\*\*/) {
          gsub(/\*\*/, "", $0)
          title = $0
        } else if ($0 ~ /published:/) {
          gsub(/published: /, "", $0)
          date = $0
        } else if (NF > 0) {
          author = $0
        }
        if (NR >= 4) {
          in_header = 0
          print "---"
          print "title: " title
          print "author: " author
          print "date: " date
          print "---"
        }
      } else {
        if ($0 !~ /<link rel="stylesheet" href="https:\/\/casual-effects.com\/markdeep\/latest\/latex.css\?">/ && $0 !~ /<!-- Markdeep: -->/ && $0 !~ /<style class="fallback">body{visibility:hidden}<\/style><script src="https:\/\/casual-effects.com\/markdeep\/latest\/markdeep.min.js\?" charset="utf-8"><\/script>/) {
          print
        }
      }
    }
  ' "$file" > "$md_file"

  # Extract title from the markdown file
  title=$(grep -m 1 "title:" "$md_file" | sed 's/title: //' | sed 's/^[ \t]*//;s/[ \t]*$//')

  # Convert title to snake_case
  snake_case_title=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '_' | sed 's/[^a-z0-9_]//g')

  # The name of the final html file
  html_file="$dir/$snake_case_title.html"

  # Convert the Markdown file to a clean HTML file using Pandoc
  pandoc "$md_file" -s -o "$html_file" --css=../elements_of.css --toc --highlight-style=pygments

  echo "Successfully converted $file to $html_file"
done

echo "All files converted."
