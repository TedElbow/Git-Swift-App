# Phase 05 Troubleshooting (Game Shell)

## Resolution log

### 2026-04-14 — OUTCOME: SUCCESS
- **Phase:** 5
- **Symptom:** Compile-only build failed with main-actor isolation error when creating `InMemoryTimerSessionStore` inside `AppDependencies.makeDefaultContainer()`.
- **Checks:** Reviewed `TroubleShooting/general.md`; manual check for `RootView` native routing; `ReadLints` on touched Swift files (`MainTabView`, `RootView`, `DependencyContainer`, `AppDependencies`, `Features/Pomodoro/*`); `xcodebuild -list -workspace "BaseProject.xcworkspace"`; compile-only `xcodebuild ... -destination 'generic/platform=iOS' build CODE_SIGNING_ALLOWED=NO`.
- **Fix:** Added `@MainActor` to `AppDependencies.makeDefaultContainer()` in `App/AppDependencies.swift` to align call site isolation with `InMemoryTimerSessionStore` initializer.
- **Verification:** `xcodebuild` compile-only build for scheme `BaseProject` succeeds (exit code 0). `RootView` still routes `.native` to `MainTabView`. No linter errors on touched phase-5 Swift files.

### 2026-04-14 — OUTCOME: SUCCESS
- **Phase:** 5 (mandatory visual pass)
- **Symptom:** Native game shell needed `chicken-color` visual theme with Swift-only styling, no asset colors/images, and fullscreen-safe background layout.
- **Checks:** Reviewed `MainTabView`, `TimerScreen`, `HistoryScreen`; applied shared palette/gradients through code-only `Color(hex:)`; verified touched files with `ReadLints`.
- **Fix:** Added `GameThemePalette` (`Core/Presentation/Views/GameThemePalette.swift`) and themed `MainTabView` tab bar + Pomodoro Timer/History screens with sky/gold/fire gradients while preserving existing view-model behavior and navigation flow.
- **Verification:** No linter diagnostics reported for touched files after theme changes.

### 2026-04-17 — OUTCOME: PARTIAL
- **Phase:** 5
- **Symptom:** Native shell had to be replaced with a habit tracker flow (`Today` + `History` + day details) using local persistence and clear completion states.
- **Checks:** Verified `RootView` still routes `.native` to `MainTabView`; added `Features/Habits/{Domain,Data,Presentation}` with protocol-based store and `@MainActor` view model; checked touched files with `ReadLints`; ran `xcodebuild -list -workspace "LittleStreakUp.xcworkspace"`; started compile-only build `xcodebuild ... -destination 'generic/platform=iOS' build CODE_SIGNING_ALLOWED=NO`.
- **Fix:** Implemented habits feature with `UserDefaults` persistence, progress computation, empty-state handling, tab navigation, and day-detail screen; rewired `MainTabView` from timer shell to habits shell.
- **Verification:** Lints are clean and workspace/schemes resolve; compile-only build command was aborted mid-run (no final success/fail verdict captured in this pass).

### 2026-04-17 — OUTCOME: SUCCESS
- **Phase:** 5 (mandatory visual pass)
- **Symptom:** Post-Phase-5 orchestrator requires explicit `chicken-color` theme pass via Designer chain for the new habits shell.
- **Checks:** Routed through `ios-designer` to `ios-design-chicken`; reviewed `MainTabView`, `TodayHabitsScreen`, `HistoryHabitsScreen`, and `GameThemePalette`; rechecked diagnostics on touched files.
- **Fix:** Applied chicken-color semantic styling adjustments (surface tokens, tab bar gradient tuning, control contrast/borders/shadows) while preserving logic and routing.
- **Verification:** Theme pass completed with Swift-only visuals and no linter issues on edited shell files.
