import Foundation

struct RoutineItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var time: Date
    var isDone = false
}

final class RoutineStore: ObservableObject {
    @Published var items: [RoutineItem] = [] {
        didSet { save() }
    }

    private let key = "rerax.items"

    init() {
        load()
    }

    func add(title: String, time: Date) {
        items.append(RoutineItem(title: title, time: time))
        items.sort { timeOfDay($0.time) < timeOfDay($1.time) }
    }

    func resetAll() {
        for i in items.indices { items[i].isDone = false }
    }

    private func timeOfDay(_ d: Date) -> Int {
        let c = Calendar.current.dateComponents([.hour, .minute], from: d)
        return (c.hour ?? 0) * 60 + (c.minute ?? 0)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([RoutineItem].self, from: data)
        else { return }
        items = decoded
    }
}
