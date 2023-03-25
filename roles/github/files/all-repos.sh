#! /bin/bash
export ALL_REPOS_CONFIG_FILENAME=".all-repos.json"
eval "$(all-repos-complete -C ~/"${ALL_REPOS_CONFIG_FILENAME}" --bash)"
