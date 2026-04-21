# Phase 03 — Credentials Troubleshooting

## Resolution log

### 2026-04-14 — OUTCOME: SUCCESS
- **Phase:** 3
- **Symptom:** Validate credentials phase after replacing `GoogleService-Info.plist` and startup defaults; ensure explicit `firebaseProjectId` is not rewritten from plist fields.
- **Checks:** Read `TroubleShooting/general.md`; `plutil -lint GoogleService-Info.plist` (OK); inspected `Infrastructure/Configuration/StartupDefaultsConfiguration.swift`; searched runtime usage in `Infrastructure/Configuration/AppConfiguration.swift` and related call sites.
- **Fix:** none
- **Verification:** `StartupDefaultsConfiguration.firebaseProjectId` remains `487557931280` (user-provided explicit value) and runtime config resolves from startup defaults / optional bundle key `FIREBASE_PROJECT_ID`; no logic maps plist `PROJECT_ID` or `GCM_SENDER_ID` into `firebaseProjectId`.

### 2026-04-17 — OUTCOME: SUCCESS
- **Phase:** 3
- **Symptom:** Credentials were updated for the new app clone: runtime defaults (`SERVER_URL`, `STORE_ID`, `FIREBASE_PROJECT_ID`, `APPSFLYER_DEV_KEY`).
- **Checks:** Read `TroubleShooting/general.md`; edited and re-read `Infrastructure/Configuration/StartupDefaultsConfiguration.swift`; validated plist syntax with `plutil -lint GoogleService-Info.plist`; verified exactly one declaration each for `serverURL`, `storeId`, `firebaseProjectId`, `appsFlyerDevKey`.
- **Fix:** Replaced startup default values with user-provided credentials (`https://moodpatth.com/config.php`, `6762453799`, `149184804217`, `BJbTQ2FWf4HbxexYxodCNF`).
- **Verification:** Credentials compile as single-line Swift string literals and plist remains parseable. Existing root `GoogleService-Info.plist` file is present and valid XML.
