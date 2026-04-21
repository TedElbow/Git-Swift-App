import SwiftUI

/// Main native shell placeholder. Extend with your tabs and content in the host app.
/// Layout follows the same fullscreen discipline as IOS-RoosterVault (GeometryReader, explicit
/// background frames, Spacer-based centering). Theme colors/gradients come from the design pass.
struct MainTabView: View {
    @StateObject private var habitsViewModel: HabitsViewModel

    init() {
        _habitsViewModel = StateObject(
            wrappedValue: HabitsViewModel(store: UserDefaultsHabitStore())
        )
    }

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            ZStack {
                GameThemePalette.skyBackgroundGradient
                    .frame(width: w, height: h)
                    .clipped()

                TabView {
                    NavigationStack {
                        TodayHabitsScreen(viewModel: habitsViewModel)
                    }
                    .tabItem {
                        Label("Today", systemImage: "sun.max.fill")
                    }

                    NavigationStack {
                        HistoryScreen(viewModel: HistoryViewModel(timerSessionStore: timerSessionStore))
                    }
                    .tabItem {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
                }
                .tint(GameThemePalette.chickenGoldenYellow)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(
                    LinearGradient(
                        colors: [
                            GameThemePalette.chickenSkyTop.opacity(0.95),
                            GameThemePalette.chickenSkyBlue.opacity(0.86)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    for: .tabBar
                )
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .frame(width: w, height: h)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
