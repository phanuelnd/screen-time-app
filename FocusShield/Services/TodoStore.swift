import Foundation
import SwiftUI

@Observable
final class TodoStore {
    private(set) var todos: [TodoItem] = []
    private let defaults: UserDefaults

    init() {
        self.defaults = UserDefaults(suiteName: AppGroupConstants.suiteName) ?? .standard
        load()
    }

    func add(_ title: String) {
        let item = TodoItem(title: title)
        todos.append(item)
        save()
    }

    func toggle(_ item: TodoItem) {
        guard let index = todos.firstIndex(where: { $0.id == item.id }) else { return }
        todos[index].isCompleted.toggle()
        save()
    }

    func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: TodoItem) {
        todos.removeAll { $0.id == item.id }
        save()
    }

    func randomIncomplete() -> TodoItem? {
        todos.filter { !$0.isCompleted }.randomElement()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(todos) else { return }
        defaults.set(data, forKey: AppGroupConstants.todosKey)
    }

    private func load() {
        guard let data = defaults.data(forKey: AppGroupConstants.todosKey),
              let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) else { return }
        todos = decoded
    }

    static func loadFromAppGroup() -> [TodoItem] {
        guard let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName),
              let data = defaults.data(forKey: AppGroupConstants.todosKey),
              let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) else { return [] }
        return decoded
    }
}
