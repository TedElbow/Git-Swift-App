import Foundation

protocol HabitStoreProtocol {
    func loadDays() -> [HabitDay]
    func saveDays(_ days: [HabitDay])
}

