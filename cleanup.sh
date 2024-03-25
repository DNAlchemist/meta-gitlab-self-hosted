#!/bin/bash
set -e

# This script is used to remove repositories from meta project that have no changes

while IFS= read -r line; do
    if [[ $line == *":" ]]; then
        # Extracting path from the line preceding git status
        repo_path=${line%:}
    elif [[ $line == *"working tree clean"* ]]; then
        echo "Repository $repo_path has no changes and will be removed."
        meta project remove "$repo_path" --confirm
        rm -rf "$repo_path"
    fi
done < <(meta git status)

echo "Done!"
