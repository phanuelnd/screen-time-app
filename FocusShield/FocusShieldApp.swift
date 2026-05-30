import SwiftUI
import FamilyControls

@main
struct FocusShieldApp: App {
    @State private var screenTimeManager = ScreenTimeManager()
    @State private var todoStore = TodoStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(screenTimeManager)
                .environment(todoStore)
        }
    }
}
