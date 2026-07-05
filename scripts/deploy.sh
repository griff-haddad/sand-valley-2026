#!/usr/bin/env bash
#
# Sand Valley 2026 dashboard deploy script.
# Copies the source HTML into the git repo, stamps a fresh build ID
# (so the "New version" toast can detect updates), and pushes to GitHub Pages.
#
# Usage:
#   ./deploy-sv2026.sh                       # uses default commit message
#   ./deploy-sv2026.sh "Fix Sunday tee time" # custom commit message

set -euo pipefail

SOURCE="/Users/griff/Downloads/sand-valley-2026.html"
DEPLOY_DIR="/tmp/sv2026-deploy"
REPO_URL="https://github.com/griff-haddad/sand-valley-2026.git"
COMMIT_MSG="${1:-Update dashboard}"

# 1. Source file must exist.
if [[ ! -f "$SOURCE" ]]; then
  echo "Source file not found: $SOURCE"
  exit 1
fi

# 2. Deploy folder — re-clone if missing (happens after /tmp is cleared on reboot).
if [[ ! -d "$DEPLOY_DIR/.git" ]]; then
  echo "Deploy folder missing, re-cloning from GitHub..."
  rm -rf "$DEPLOY_DIR"
  git clone "$REPO_URL" "$DEPLOY_DIR"
  cd "$DEPLOY_DIR"
  git config user.email "griffin@graycapitalllc.com"
  git config user.name "griff-haddad"
  cd - > /dev/null
fi

# 3. Copy source to deploy.
cp "$SOURCE" "$DEPLOY_DIR/index.html"

# 4. Stamp a fresh build ID so the update-detection toast can detect a change.
BUILD_ID=$(date +"%Y%m%d-%H%M%S")
sed -i.bak "s/name=\"build-id\" content=\"[^\"]*\"/name=\"build-id\" content=\"$BUILD_ID\"/" "$DEPLOY_DIR/index.html"
rm -f "$DEPLOY_DIR/index.html.bak"

# 5. Commit and push (only if there are actual changes).
cd "$DEPLOY_DIR"
if git diff --quiet index.html; then
  echo "No changes to deploy — source file is identical to the last deploy."
  exit 0
fi
git add index.html
git commit -m "$COMMIT_MSG (build $BUILD_ID)" > /dev/null
git push origin main > /dev/null 2>&1

echo "✓ Deployed. Build ID: $BUILD_ID"
echo "  Live URL: https://griff-haddad.github.io/sand-valley-2026/"
echo "  GitHub Pages will rebuild in about 30 seconds."
