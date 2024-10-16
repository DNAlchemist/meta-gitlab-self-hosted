#!/bin/bash
set -e

PER_PAGE=100  # Maximum number of projects per page
GITLAB_API=api/v4

rm -rf ./root/

rm .meta
git checkout .gitignore
meta init

# Page number
page=1

while :
do
    # Use GitLab API to get a list of projects
    response=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_DOMAIN/$GITLAB_API/projects?membership=true&per_page=$PER_PAGE&page=$page")

    # Check if the response is an object (for error) or array (for projects)
    if echo "$response" | jq 'type' | grep -q '"object"'; then
        error_message=$(echo "$response" | jq -r '.error // empty')
        if [ -n "$error_message" ]; then
            error_description=$(echo "$response" | jq -r '.error_description // empty')
            echo "Error: $error_message"
            if [ -n "$error_description" ]; then
                echo "Description: $error_description"
            fi
            exit 1
        fi
    fi

    # Check if the response is empty (i.e., we've reached the end of the project list)
    if [ "$(echo $response | jq '. | length')" == "0" ]; then
        break
    fi

    # Parse the JSON response to get the project paths
    project_paths=$(echo $response | jq -r '.[].path_with_namespace')

    # Loop through each project path and add it to the meta project
    for path in $project_paths
    do
        ssh_path=$(echo $path | sed 's/:/\//g')
        git_url="$SSH_DOMAIN:$ssh_path.git"
        meta project import root/$path $git_url
    done

    # Increment the page number
    ((page++))
done

echo "Done!"
