import SwiftUI

struct TodayHabitsScreen: View {
    @ObservedObject var viewModel: HabitsViewModel
    @State private var newHabitTitle = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            let safeTop = geometry.safeAreaInsets.top
            let today = viewModel.todayDay
            let progressPercent = Int((today.progressFraction * 100).rounded())

            ZStack {
                GameThemePalette.skyBackgroundGradient
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today")
                            .font(AppTypography.title)
                            .foregroundStyle(GameThemePalette.chickenWhite)

                        Text(today.date.formatted(date: .complete, time: .omitted))
                            .font(AppTypography.callout)
                            .foregroundStyle(GameThemePalette.chickenWhite.opacity(0.92))

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Progress: \(progressPercent)%")
                                .font(AppTypography.headline)
                                .foregroundStyle(GameThemePalette.chickenWhite)

                            ProgressView(value: today.progressFraction)
                                .tint(GameThemePalette.chickenGoldenYellow)
                        }
                        .padding()
                        .background(
                            GameThemePalette.elevatedSurface,
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(GameThemePalette.chickenWhite.opacity(0.28), lineWidth: 1)
                        }

                        TextField("Add a personal task for today", text: $newHabitTitle)
                            .focused($isInputFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                viewModel.addHabit(title: newHabitTitle, for: today.id)
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

                        if today.habits.isEmpty {
                            Text("🌱 No habits planned for today yet. Start small and build a streak!")
                                .font(AppTypography.body)
                                .foregroundStyle(GameThemePalette.chickenWhite)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    GameThemePalette.elevatedSurface,
                                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(GameThemePalette.chickenWhite.opacity(0.28), lineWidth: 1)
                                }
                        } else {
                            VStack(spacing: 10) {
                                ForEach(today.habits) { habit in
                                    HabitRow(
                                        habit: habit,
                                        onDoneTap: {
                                            viewModel.toggleHabitDone(for: today.id, habitID: habit.id)
                                        }
                                    )
                                }
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
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct HabitRow: View {
    let habit: HabitItem
    let onDoneTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(habit.isDone ? "✅" : "🕒")
                .font(.title3)

            Text(habit.title)
                .font(AppTypography.body)
                .foregroundStyle(habit.isDone ? GameThemePalette.chickenWhite.opacity(0.9) : GameThemePalette.chickenWhite)
                .strikethrough(habit.isDone, color: GameThemePalette.chickenWhite.opacity(0.9))

            Spacer()

            Button(action: onDoneTap) {
                Text(habit.isDone ? "Undo" : "Done")
                    .font(AppTypography.callout)
                    .foregroundStyle(GameThemePalette.primaryControlText)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        GameThemePalette.goldControlGradient,
                        in: Capsule(style: .continuous)
                    )
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(GameThemePalette.chickenWhite.opacity(0.68), lineWidth: 1)
                    }
                    .shadow(color: GameThemePalette.chickenAccentBrown.opacity(0.35), radius: 2, x: 0, y: 1)
            }
        }
        .padding(14)
        .background(
            (habit.isDone ? GameThemePalette.chickenSkyBlue.opacity(0.42) : GameThemePalette.secondarySurface),
            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(habit.isDone ? GameThemePalette.chickenGoldenYellow : Color.white.opacity(0.2), lineWidth: 1)
        }
    }
}

