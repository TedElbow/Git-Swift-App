# Phase 2 Troubleshooting (CocoaPods)

## Resolution log

### 2026-04-14 — OUTCOME: SUCCESS
- **Phase:** 2
- **Symptom:** Post-phase verification requested after CocoaPods integration; no active error reproduced.
- **Checks:** Read `TroubleShooting/general.md`; verified `objectVersion = 77` in `BaseProject.xcodeproj/project.pbxproj`; confirmed `Podfile.lock` exists; ran `xcodebuild -list -workspace "BaseProject.xcworkspace"` and validated workspace/schemes including `Pods-PodsShared-BaseProject`.
- **Fix:** none
- **Verification:** All phase-2 minimum checks passed with successful command exit status and expected artifacts present.

### 2026-04-17 — OUTCOME: PARTIAL
- **Phase:** 2
- **Symptom:** Required command `bundle exec pod install` could not run because the machine Ruby is `2.6.10` while `Gemfile.lock` requires Bundler `4.0.4` (Ruby `>= 3.2`).
- **Checks:** Updated `objectVersion` to `77` in `LittleStreakUp.xcodeproj/project.pbxproj`; attempted `bundle exec pod install`; checked `ruby -v`, `which bundle`; executed `xcodebuild -list -workspace "LittleStreakUp.xcworkspace"`.
- **Fix:** Applied compatible fallback `pod install` with UTF-8 locale (`LANG`/`LC_ALL`) to regenerate Pods and workspace integration after rename.
- **Verification:** `pod install` completed successfully and `LittleStreakUp.xcworkspace` lists expected app schemes (`LittleStreakUp`, `notifications`, `Pods-PodsShared-LittleStreakUp`). Bundler mismatch remains an environment issue.
