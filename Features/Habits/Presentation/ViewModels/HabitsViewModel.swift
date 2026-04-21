import Foundation

@MainActor
final class HabitsViewModel: ObservableObject {
    @Published private(set) var days: [HabitDay] = []

    private let store: HabitStoreProtocol

    init(store: HabitStoreProtocol) {
        self.store = store
        self.days = store.loadDays().sorted { $0.date > $1.date }
        ensureTodayDayExists()
    }

    var todayDay: HabitDay {
        let todayID = UserDefaultsHabitStore.dayID(from: Date())
        if let day = days.first(where: { $0.id == todayID }) {
            return day
        }
        return HabitDay(id: todayID, date: Calendar.current.startOfDay(for: Date()), habits: [])
    }

    var sortedHistoryDays: [HabitDay] {
        days.sorted { $0.date > $1.date }
    }

    func day(for dayID: String) -> HabitDay? {
        days.first(where: { $0.id == dayID })
    }

    func toggleHabitDone(for dayID: String, habitID: UUID) {
        guard let dayIndex = days.firstIndex(where: { $0.id == dayID }),
              let habitIndex = days[dayIndex].habits.firstIndex(where: { $0.id == habitID }) else { return }

        days[dayIndex].habits[habitIndex].isDone.toggle()
        persist()
    }

    func addHabit(title: String, for dayID: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        if let index = days.firstIndex(where: { $0.id == dayID }) {
            days[index].habits.append(
                HabitItem(id: UUID(), title: trimmedTitle, isDone: false)
            )
            persist()
            return
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        let parsedDate = formatter.date(from: dayID) ?? Date()

        let newDay = HabitDay(
            id: dayID,
            date: Calendar.current.startOfDay(for: parsedDate),
            habits: [HabitItem(id: UUID(), title: trimmedTitle, isDone: false)]
        )
        days.append(newDay)
        persist()
    }

    private func ensureTodayDayExists() {
        let todayID = UserDefaultsHabitStore.dayID(from: Date())
        guard !days.contains(where: { $0.id == todayID }) else {
            persist()
            return
        }

        let newDay = HabitDay(
            id: todayID,
            date: Calendar.current.startOfDay(for: Date()),
            habits: [
                HabitItem(id: UUID(), title: "Morning walk", isDone: false),
                HabitItem(id: UUID(), title: "Meditate 5 min", isDone: false),
                HabitItem(id: UUID(), title: "Read 10 pages", isDone: false)
            ]
        )
        days.append(newDay)
        persist()
    }

    private func persist() {
        days.sort { $0.date > $1.date }
        store.saveDays(days)
    }
}

