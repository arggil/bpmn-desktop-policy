#!/usr/bin/env bash
#
# Sign the version policy with the minisign key and (optionally) publish it.
#
# Usage:
#   ./sign.sh                # sign version-policy.json -> version-policy.json.sig
#   ./sign.sh --push         # sign, commit and push
#
set -euo pipefail

cd "$(dirname "$0")"

PRIVATE_KEY="${TAURI_SIGNING_PRIVATE_KEY_PATH:-$HOME/.tauri/bpmn-desktop-policy.key}"
PASSWORD="${TAURI_SIGNING_PRIVATE_KEY_PASSWORD:-}"

if [ ! -f "$PRIVATE_KEY" ]; then
  echo "Private key not found: $PRIVATE_KEY" >&2
  echo "Generate it with: npx tauri signer generate -w \"$PRIVATE_KEY\" -p \"\" --ci" >&2
  exit 1
fi

echo "Signing version-policy.json ..."
npx tauri signer sign -f "$PRIVATE_KEY" -p "$PASSWORD" version-policy.json

echo "Signature written to version-policy.json.sig"

if [ "${1:-}" = "--push" ]; then
  git add version-policy.json version-policy.json.sig
  git commit -m "Update version policy"
  git push
fi
