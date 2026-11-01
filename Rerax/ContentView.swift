import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: RoutineStore
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if store.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("Noch keine Routine")
                            .font(.headline)
                        Text("Tippe auf +, um deinen ersten Punkt hinzuzufügen.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach($store.items) { $item in
                            HStack {
                                Button {
                                    item.isDone.toggle()
                                } label: {
                                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                }
                                .buttonStyle(.plain)

                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .strikethrough(item.isDone)
                                        .foregroundColor(item.isDone ? .secondary : .primary)
                                    Text(item.time, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete { store.items.remove(atOffsets: $0) }
                    }
                }
            }
            .navigationTitle("Rerax")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Zurücksetzen") { store.resetAll() }
                        .disabled(store.items.isEmpty)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddView()
            }
        }
    }
}

struct AddView: View {
    @EnvironmentObject var store: RoutineStore
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var time = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Was machst du?", text: $title)
                DatePicker("Uhrzeit", selection: $time, displayedComponents: .hourAndMinute)
            }
            .navigationTitle("Neuer Punkt")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Hinzufügen") {
                        store.add(title: title.trimmingCharacters(in: .whitespaces), time: time)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
