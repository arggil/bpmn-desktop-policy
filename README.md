# BPMN Desktop — Version Policy

Public **kill-switch / version revocation** policy for the BPMN Desktop app.

The application fetches these files at startup, verifies the signature with an
embedded public key, and blocks itself if the running version is revoked or below
`minVersion`.

## Files

- `version-policy.json` — the policy (see schema below).
- `version-policy.json.sig` — minisign signature of the policy.

Raw URLs used by the app:

- `https://raw.githubusercontent.com/arggil/bpmn-desktop-policy/main/version-policy.json`
- `https://raw.githubusercontent.com/arggil/bpmn-desktop-policy/main/version-policy.json.sig`

## Policy schema

```json
{
  "schema": 1,
  "minVersion": "0.0.0",
  "revokedVersions": [],
  "message": "Shown to the user when the version is blocked.",
  "issuedAt": "2026-10-15T00:00:00Z"
}
```

- `minVersion` — versions **below** this are blocked.
- `revokedVersions` — exact versions that are blocked.
- `message` — shown in the blocking dialog.

## Signing (minisign via Tauri signer)

The private key is **never** committed. Generate it once:

```sh
npx tauri signer generate -w ~/.tauri/bpmn-desktop-policy.key -p "" --ci
```

Sign after editing the policy (see `sign.sh`):

```sh
npx tauri signer sign -f ~/.tauri/bpmn-desktop-policy.key -p "" version-policy.json
```

This (re)creates `version-policy.json.sig`. Commit and push both files.

## How to disable a version

1. Add the version to `revokedVersions` (or raise `minVersion`).
2. Update `message` and `issuedAt`.
3. Sign (`sign.sh`), commit and push.
