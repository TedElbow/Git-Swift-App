import Foundation

final class UserDefaultsHabitStore: HabitStoreProtocol {
    private let key = "habit_tracker_days"
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func loadDays() -> [HabitDay] {
        guard let data = defaults.data(forKey: key),
              let days = try? decoder.decode([HabitDay].self, from: data) else {
            return Self.seedDays()
        }
        return days
    }

    func saveDays(_ days: [HabitDay]) {
        guard let data = try? encoder.encode(days) else { return }
        defaults.set(data, forKey: key)
    }

    private static func seedDays() -> [HabitDay] {
        let calendar = Calendar.current
        let now = Date()
        let titles = [
            "Drink water",
            "10 min stretch",
            "Read 15 minutes",
            "No sugar snack"
        ]

        let today = HabitDay(
            id: dayID(from: now),
            date: calendar.startOfDay(for: now),
            habits: titles.map { HabitItem(id: UUID(), title: $0, isDone: false) }
        )

        let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: now) ?? now
        let yesterday = HabitDay(
            id: dayID(from: yesterdayDate),
            date: calendar.startOfDay(for: yesterdayDate),
            habits: [
                HabitItem(id: UUID(), title: "Drink water", isDone: true),
                HabitItem(id: UUID(), title: "10 min stretch", isDone: true),
                HabitItem(id: UUID(), title: "Read 15 minutes", isDone: false)
            ]
        )

        return [today, yesterday]
    }

    static func dayID(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

