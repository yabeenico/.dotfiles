#!/bin/bash

git filter-branch -f --commit-filter '
    GIT_AUTHOR_NAME="yabeenico"
    GIT_AUTHOR_EMAIL="<>"
    GIT_COMMITTER_NAME="yabeenico"
    GIT_COMMITTER_EMAIL="<>"
    git commit-tree "$@"
' HEAD
