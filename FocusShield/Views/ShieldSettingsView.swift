import SwiftUI
import FamilyControls

struct ShieldSettingsView: View {
    @Environment(ScreenTimeManager.self) private var manager
    @State private var showingAppPicker = false
    @State private var isMonitoring = false

    var body: some View {
        @Bindable var manager = manager

        NavigationStack {
            Form {
                Section {
                    Button {
                        showingAppPicker = true
                    } label: {
                        HStack {
                            Label("Select Apps to Shield", systemImage: "apps.iphone")
                            Spacer()
                            if !manager.activitySelection.applicationTokens.isEmpty {
                                Text("\(manager.activitySelection.applicationTokens.count) selected")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .familyActivityPicker(
                        isPresented: $showingAppPicker,
                        selection: $manager.activitySelection
                    )
                } header: {
                    Text("Apps")
                } footer: {
                    Text("Browse and choose any apps you want to limit.")
                }

                Section {
                    Stepper(
                        "Daily limit: \(manager.dailyLimitMinutes) min",
                        value: $manager.dailyLimitMinutes,
                        in: 5...480,
                        step: 5
                    )

                    HStack {
                        Text("That's")
                        Spacer()
                        Text(formattedTime)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Time Limit")
                } footer: {
                    Text("After this much usage in a day, the shield will activate and ask if you really need the app.")
                }

                Section {
                    if isMonitoring {
                        Button(role: .destructive) {
                            manager.stopMonitoring()
                            isMonitoring = false
                        } label: {
                            Label("Stop Monitoring", systemImage: "stop.circle")
                        }
                    } else {
                        Button {
                            manager.saveSelection()
                            manager.startMonitoring()
                            isMonitoring = true
                        } label: {
                            Label("Start Monitoring", systemImage: "play.circle.fill")
                        }
                        .disabled(manager.activitySelection.applicationTokens.isEmpty)
                    }
                } header: {
                    Text("Monitoring")
                } footer: {
                    if manager.activitySelection.applicationTokens.isEmpty {
                        Text("Select at least one app above to enable monitoring.")
                    } else if isMonitoring {
                        Text("FocusShield is actively monitoring your usage. The shield will appear after \(manager.dailyLimitMinutes) minutes of use today.")
                    }
                }

                Section {
                    Button("Shield Apps Now (Test)") {
                        manager.shieldSelectedApps()
                    }
                    .disabled(manager.activitySelection.applicationTokens.isEmpty)

                    Button("Remove Shield") {
                        manager.unshieldApps()
                    }
                } header: {
                    Text("Debug")
                } footer: {
                    Text("Manually trigger the shield to test how it looks.")
                }
            }
            .navigationTitle("Shield")
        }
    }

    private var formattedTime: String {
        let hours = manager.dailyLimitMinutes / 60
        let minutes = manager.dailyLimitMinutes % 60
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
}
