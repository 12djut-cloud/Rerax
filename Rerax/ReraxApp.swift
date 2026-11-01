import SwiftUI

@main
struct ReraxApp: App {
    @StateObject private var store = RoutineStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
