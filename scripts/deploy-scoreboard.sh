#!/usr/bin/env bash
#
# Sand Valley Cup scoreboard deploy.
# Stamps a fresh build ID (so the "New scores posted" toast fires for anyone
# with the page open), commits, and pushes. Run it from anywhere inside the repo.
#
# Usage:
#   ./scripts/deploy-scoreboard.sh                        # default commit message
#   ./scripts/deploy-scoreboard.sh "Wednesday scores in"  # custom message

set -euo pipefail

# Move to repo root (this script lives in scripts/).
cd "$(dirname "$0")/.."

FILE="scoreboard/index.html"
COMMIT_MSG="${1:-Update scoreboard}"

if [[ ! -f "$FILE" ]]; then
  echo "Not found: $FILE (run from inside the sand-valley-2026 repo)"
  exit 1
fi

BUILD_ID=$(date +"%Y%m%d-%H%M%S")
sed -i.bak "s/name=\"build-id\" content=\"[^\"]*\"/name=\"build-id\" content=\"$BUILD_ID\"/" "$FILE"
rm -f "$FILE.bak"

if git diff --quiet "$FILE"; then
  echo "No changes to deploy — scoreboard is identical to the last deploy."
  exit 0
fi

git add "$FILE"
git commit -m "$COMMIT_MSG (build $BUILD_ID)" > /dev/null
git push origin main > /dev/null 2>&1

echo "✓ Scoreboard deployed. Build ID: $BUILD_ID"
echo "  Live URL: https://griff-haddad.github.io/sand-valley-2026/scoreboard/"
echo "  GitHub Pages will rebuild in about 30 seconds."
