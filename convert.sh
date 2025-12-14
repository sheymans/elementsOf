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
  awk -v dir="$dir" '
    function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
    function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
    function trim(s)  { return rtrim(ltrim(s)); }

    BEGIN {
      in_header = 1
      header_processed = 0
      in_script_block = 0
    }
    # Skip Markdeep-specific lines
    /<meta|<link rel="stylesheet"|<script>|<!-- Markdeep: -->|<style class="fallback">/ { next }

    /<!-- Global site tag/ { in_script_block = 1 }
    in_script_block {
        if ($0 ~ /latex.css/) {
            in_script_block = 0
        } else {
            next
        }
    }

    # Process header
    in_header && NF > 0 {
      if ($0 ~ /\*\*/) {
        gsub(/\*\*|^\s+|\s+$/, "", $0);
        title = $0
      } else if ($0 ~ /published:/) {
        gsub(/published: |^\s+|\s+$/, "", $0);
        date = $0
      } else {
        author = trim($0)
      }
      # If we have processed 4 lines or we hit a line that looks like a markdown header, end header processing
      if (NR >= 4 || $0 ~ /^#/) {
        in_header = 0
        header_processed = 1
        print "---"
        if (title) print "title: " title
        if (author) print "author: " author
        if (date) print "date: " date
        print "---"
        if ($0 !~ /^#/) next # Dont consume the markdown header line
      } else {
        next
      }
    }

    # If the header was not processed (e.g. file with no metadata), but we are past the first few lines
    !header_processed && NR > 4 {
        in_header = 0
        header_processed = 1
    }


    # Process includes
    /^\(insert .* here\)$/ {
        # extract the file path
        gsub(/^\(insert /, "", $0)
        gsub(/ here\)$/, "", $0)
        include_file = dir "/" $0
        while ( (getline line < include_file) > 0 ) {
            print line
        }
        close(include_file)
        next
    }

    # Process warning blocks
    /^[ \t]*!!!/ {
        if (in_warning) print ":::" # Close previous block if needed
        in_warning = 1
        print "\n::: warning"
        # Check if there is text on the same line
        sub(/^[ \t]*!!![ \t]*/, "")
        if (NF > 0) {
            print trim($0)
        }
        next
    }

    # If we are in a warning block
    in_warning {
        # If we find a line that is not indented, it ends the block
        if ($0 !~ /^[ \t]/ && NF > 0) {
            print ":::"
            in_warning = 0
            # Fall through to print the current line
        } else {
            print trim($0)
            next
        }
    }

    # Print all other lines
    { print }

    END {
        if (in_warning) print ":::" # Close any open block at the end
    }
  ' "$file" > "$md_file"

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
  pandoc "$md_file" -s -o "$html_file" --css=../elements_of.css --toc --highlight-style=pygments --include-after-body analytics.html --filter mermaid-filter

  echo "Successfully converted $file to $html_file"
done

echo "All files converted."