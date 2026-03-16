#!/bin/bash
# setup.sh — Clone one or more repos into the workspace.
#
# Usage:
#   ./setup.sh <git-url>
#   ./setup.sh <git-url> <git-url2> ...
#
# After cloning, open Claude Code and run:
#   /init <repo-name>

set -e

WORKSPACE_DIR="$(cd "$(dirname "$0")" && pwd)"
REPOS_DIR="$WORKSPACE_DIR/repos"

mkdir -p "$REPOS_DIR"
mkdir -p "$WORKSPACE_DIR/.data-agent"

if [ $# -eq 0 ]; then
    echo "Usage: ./setup.sh <git-url> [<git-url2> ...]"
    echo ""
    echo "Example:"
    echo "  ./setup.sh https://github.com/bagisto/bagisto"
    echo ""
    echo "Then inside Claude Code:"
    echo "  /init bagisto"
    exit 0
fi

for URL in "$@"; do
    REPO_NAME=$(basename "$URL" .git)
    if [ -d "$REPOS_DIR/$REPO_NAME" ]; then
        echo "✓ Already exists: repos/$REPO_NAME"
    else
        echo "Cloning $REPO_NAME..."
        git clone "$URL" "$REPOS_DIR/$REPO_NAME"
        echo "✓ Cloned: repos/$REPO_NAME"
    fi
done

echo ""
echo "Done. Open Claude Code and run /init <repo-name> to build the data map."
