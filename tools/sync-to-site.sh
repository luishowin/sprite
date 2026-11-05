#!/usr/bin/env bash
# Copy the standalone Sprite build into a beben.design checkout.
#
#   tools/sync-to-site.sh /path/to/beben.design 8.1
#
# The site vendors sprite.js and sprite.css under docs/assets. All four
# shared assets (index.css, index.js, sprite.css, sprite.js) use the same
# version query string, so this updates both file copies and every include.

set -euo pipefail

SITE="${1:-}"
VERSION="${2:-}"

if [ -z "$SITE" ] || [ ! -d "$SITE/docs/assets" ]; then
  echo "usage: $0 /path/to/beben.design <version>" >&2
  exit 1
fi

if [ -z "$VERSION" ]; then
  echo "usage: $0 /path/to/beben.design <version>" >&2
  echo "example: $0 ../beben.design 8.1" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cp "$ROOT/sprite.js" "$SITE/docs/assets/JS/sprite.js"
cp "$ROOT/sprite.css" "$SITE/docs/assets/css/sprite.css"

# Keep every shared asset on the same version. The site check expects exactly
# one value from this grep:
#   grep -rhoE '(index|sprite)\.(css|js)\?v=[0-9.]+' docs scripts --include=*.html | sort -u
find "$SITE/docs" "$SITE/scripts/templates" -type f -name '*.html' -print0 \
  | xargs -0 perl -pi -e "s/((?:index|sprite)\.(?:css|js))\?v=[0-9.]+/\$1?v=$VERSION/g"

echo "Synced Sprite into $SITE at asset version $VERSION."
echo "Next: run the site checks and test the widget in a browser."
