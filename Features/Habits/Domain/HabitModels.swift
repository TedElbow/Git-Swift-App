import Foundation

struct HabitItem: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    var isDone: Bool
}

struct HabitDay: Identifiable, Codable, Equatable {
    let id: String
    let date: Date
    var habits: [HabitItem]
}

extension HabitDay {
    var completedCount: Int {
        habits.filter(\.isDone).count
    }

    var totalCount: Int {
        habits.count
    }

    var progressFraction: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
}

