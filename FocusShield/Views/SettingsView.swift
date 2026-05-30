import SwiftUI

struct SettingsView: View {
    @Environment(ScreenTimeManager.self) private var manager

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Screen Time Access")
                        Spacer()
                        Image(systemName: manager.isAuthorized ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(manager.isAuthorized ? .green : .red)
                    }
                } header: {
                    Text("Permissions")
                }

                Section {
                    Link(destination: URL(string: "x-apple.systempreferences:com.apple.Screen-Time")!) {
                        Label("Open Screen Time Settings", systemImage: "hourglass")
                    }
                } header: {
                    Text("System")
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("FocusShield v1.0")
                            .font(.headline)
                        Text("Built to help you reclaim your time from endless WhatsApp scrolling. Add activities you'd rather be doing, and we'll remind you when it's time to step away.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
