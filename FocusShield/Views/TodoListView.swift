import SwiftUI

struct TodoListView: View {
    @Environment(TodoStore.self) private var store
    @State private var showingAddSheet = false
    @State private var newTodoTitle = ""

    var incompleteTodos: [TodoItem] {
        store.todos.filter { !$0.isCompleted }
    }

    var completedTodos: [TodoItem] {
        store.todos.filter { $0.isCompleted }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.todos.isEmpty {
                    emptyState
                } else {
                    todoList
                }
            }
            .navigationTitle("Activities")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTodoSheet(isPresented: $showingAddSheet)
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Activities Yet", systemImage: "checklist")
        } description: {
            Text("Add things you'd rather be doing instead of scrolling WhatsApp. When the shield activates, we'll suggest one of these.")
        } actions: {
            Button("Add Activity") {
                showingAddSheet = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
        }
    }

    private var todoList: some View {
        List {
            if !incompleteTodos.isEmpty {
                Section("To Do") {
                    ForEach(incompleteTodos) { item in
                        TodoRow(item: item)
                    }
                    .onDelete { offsets in
                        let items = offsets.map { incompleteTodos[$0] }
                        items.forEach { store.delete($0) }
                    }
                }
            }

            if !completedTodos.isEmpty {
                Section("Completed") {
                    ForEach(completedTodos) { item in
                        TodoRow(item: item)
                    }
                    .onDelete { offsets in
                        let items = offsets.map { completedTodos[$0] }
                        items.forEach { store.delete($0) }
                    }
                }
            }
        }
    }
}

private struct TodoRow: View {
    @Environment(TodoStore.self) private var store
    let item: TodoItem

    var body: some View {
        Button {
            withAnimation {
                store.toggle(item)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
                    .font(.title3)

                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
            }
        }
    }
}

struct AddTodoSheet: View {
    @Environment(TodoStore.self) private var store
    @Binding var isPresented: Bool
    @State private var title = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("What would you rather be doing?", text: $title)
                        .focused($isFocused)
                }

                Section {
                    Text("Examples: Read a book, Go for a walk, Call a friend, Practice guitar, Meditate, Cook something new")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty {
                            store.add(trimmed)
                            isPresented = false
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                isFocused = true
            }
        }
        .presentationDetents([.medium])
    }
}
