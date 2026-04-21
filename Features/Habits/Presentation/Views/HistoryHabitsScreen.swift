import SwiftUI

struct HistoryHabitsScreen: View {
    @ObservedObject var viewModel: HabitsViewModel

    var body: some View {
        GeometryReader { geometry in
            let safeTop = geometry.safeAreaInsets.top

            ZStack {
                GameThemePalette.skyBackgroundGradient
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("📚 History")
                            .font(AppTypography.title)
                            .foregroundStyle(GameThemePalette.chickenWhite)

                        ForEach(viewModel.sortedHistoryDays) { day in
                            NavigationLink {
                                HabitDayDetailScreen(
                                    dayID: day.id,
                                    viewModel: viewModel
                                )
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(day.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(AppTypography.headline)
                                        .foregroundStyle(GameThemePalette.chickenWhite)

                                    Text("\(day.completedCount) из \(day.totalCount) выполнено")
                                        .font(AppTypography.body)
                                        .foregroundStyle(GameThemePalette.chickenWhite.opacity(0.9))

                                    ProgressView(value: day.progressFraction)
                                        .tint(GameThemePalette.chickenGoldenYellow)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(GameThemePalette.secondarySurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .padding(.top, max(safeTop, 16))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct HabitDayDetailScreen: View {
    let dayID: String
    @ObservedObject var viewModel: HabitsViewModel
    @State private var newHabitTitle = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        let day = viewModel.day(for: dayID) ?? HabitDay(id: dayID, date: Date(), habits: [])
        GeometryReader { geometry in
            let safeTop = geometry.safeAreaInsets.top
            ZStack {
                GameThemePalette.skyBackgroundGradient
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("🗓️ \(day.date.formatted(date: .long, time: .omitted))")
                            .font(AppTypography.title3)
                            .foregroundStyle(GameThemePalette.chickenWhite)

                        TextField("Add a personal task for this day", text: $newHabitTitle)
                            .focused($isInputFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                viewModel.addHabit(title: newHabitTitle, for: dayID)
                                newHabitTitle = ""
                                isInputFocused = false
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(GameThemePalette.chickenWhite.opacity(0.95))
                            .foregroundStyle(GameThemePalette.chickenSkyTop)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(GameThemePalette.chickenSkyBlue.opacity(0.8), lineWidth: 1)
                            }

                        ForEach(day.habits) { habit in
                            HStack(spacing: 10) {
                                Text(habit.isDone ? "✅" : "⭕️")
                                Text(habit.title)
                                    .font(AppTypography.body)
                                    .foregroundStyle(GameThemePalette.chickenWhite)
                                Spacer()
                                Text(habit.isDone ? "Done" : "Pending")
                                    .font(AppTypography.footnote)
                                    .foregroundStyle(habit.isDone ? GameThemePalette.chickenGoldenYellow : GameThemePalette.chickenWhite.opacity(0.8))
                            }
                            .padding(12)
                            .background(
                                (habit.isDone ? GameThemePalette.chickenSkyBlue.opacity(0.35) : GameThemePalette.secondarySurface),
                                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(
                                        habit.isDone ? GameThemePalette.chickenGoldenYellow.opacity(0.9) : GameThemePalette.chickenWhite.opacity(0.2),
                                        lineWidth: 1
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .padding(.top, max(safeTop, 16))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
        .navigationTitle("Day details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

