import SwiftUI
import FamilyControls

struct ContentView: View {
    @Environment(ScreenTimeManager.self) private var screenTimeManager

    var body: some View {
        Group {
            if screenTimeManager.isAuthorized {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Activities", systemImage: "checklist") {
                TodoListView()
            }
            Tab("Shield", systemImage: "shield.checkered") {
                ShieldSettingsView()
            }
            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
            }
        }
        .tint(.indigo)
    }
}
