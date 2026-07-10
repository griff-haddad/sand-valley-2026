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
CUP="scoreboard/cup.json"
COMMIT_MSG="${1:-Update scoreboard}"

if [[ ! -f "$FILE" ]]; then
  echo "Not found: $FILE (run from inside the sand-valley-2026 repo)"
  exit 1
fi

BUILD_ID=$(date +"%Y%m%d-%H%M%S")
sed -i.bak "s/name=\"build-id\" content=\"[^\"]*\"/name=\"build-id\" content=\"$BUILD_ID\"/" "$FILE"
rm -f "$FILE.bak"

# cup.json feeds the ticker on the itinerary page. It changes on its own schedule,
# so include it whenever it has been edited.
if git diff --quiet "$FILE" "$CUP"; then
  echo "No changes to deploy — scoreboard is identical to the last deploy."
  exit 0
fi

git add "$FILE" "$CUP"
git commit -m "$COMMIT_MSG (build $BUILD_ID)" > /dev/null

# The itinerary deploys from a separate clone, so origin may be ahead of this
# one. Rebase onto it before pushing so we never fail with a non-fast-forward.
git pull --rebase origin main

if ! git push origin main; then
  echo "Push failed (see the error above). Fix it, then run: git push origin main"
  exit 1
fi

echo "✓ Scoreboard deployed. Build ID: $BUILD_ID"
echo "  Live URL: https://griff-haddad.github.io/sand-valley-2026/scoreboard/"
echo "  GitHub Pages will rebuild in about 30 seconds."
