# BPMN Desktop — Version Policy

Public **kill-switch / version revocation** policy for the BPMN Desktop app.

The application fetches these files at startup, verifies the signature with an
embedded public key, and blocks itself if the running version is revoked or below
`minVersion`.

> **Default: all versions are allowed.** The committed policy uses
> `minVersion: "0.0.0"` and an empty `revokedVersions`, so no release is blocked.
> Blocking is **opt-in** and applied at the maintainer's discretion (e.g. a
> broken or unsafe release).

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

## How to disable a version (optional, maintainer discretion)

Nothing is blocked unless you explicitly change the policy.

1. Add the version to `revokedVersions` (or raise `minVersion`).
2. Update `message` and `issuedAt`.
3. Sign (`sign.sh`), commit and push.

To restore the default (allow everything), set `minVersion` back to `"0.0.0"`,
empty `revokedVersions`, re-sign and push.
