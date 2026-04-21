# Phase 04 — Brand Assets Troubleshooting

## Resolution log

### 2026-04-14 — OUTCOME: SUCCESS
- **Phase:** 4
- **Symptom:** Validate brand-assets phase after asset set refresh, app icon replacement, and Paytone font wiring.
- **Checks:** Read `TroubleShooting/general.md`; inspected git changes for `Resources/Assets.xcassets/*` and `Resources/Fonts/PaytoneOne-Regular.ttf`; validated all `Resources/Assets.xcassets/**/Contents.json` with Python JSON parse; verified referenced image files exist on disk; checked `BaseProject-Info.plist` contains `UIAppFonts -> Fonts/PaytoneOne-Regular.ttf`; confirmed `Core/Presentation/Theme/AppTypography.swift` uses `PaytoneOne-Regular`; ran `xcodebuild -list -workspace BaseProject.xcworkspace`.
- **Fix:** none
- **Verification:** All Phase 4 target assets are present and structurally valid, font file exists and is registered in plist/typography, and workspace scheme listing succeeds (`BaseProject`, `notifications`).

### 2026-04-17 — OUTCOME: SUCCESS
- **Phase:** 4
- **Symptom:** New white-label brand pack needed to replace all required catalog assets and switch app typography to custom font.
- **Checks:** Copied and mapped user assets to canonical names (`internetBackground`, `loadingBackground`, `logo`, `notificationBackground`, `notificationButton`, `frame`, `AppIcon`); generated `AppIcon.appiconset` sizes from 1024 master; validated all `Resources/Assets.xcassets/**/Contents.json` via Python JSON parse; checked `LittleStreakUp-Info.plist` with `plutil -lint`; verified `UIAppFonts` and `AppTypography` PostScript name.
- **Fix:** Replaced required imagesets, rebuilt `AppIcon.appiconset`, added `Resources/Fonts/PlumbSoft.ttf`, updated `UIAppFonts` to `Fonts/PlumbSoft.ttf`, switched typography PostScript to `PlumbSoft-Black`.
- **Verification:** Plist and asset JSON validation succeeded; workspace remains valid for scheme listing.
