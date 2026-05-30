import DeviceActivity
import ManagedSettings
import FamilyControls
import Foundation

final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        store.shield.applications = nil
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        store.shield.applications = nil
    }

    override func eventDidReachThreshold(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName
    ) {
        super.eventDidReachThreshold(event, activity: activity)

        guard event == .usageThresholdReached else { return }

        let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)
        if let data = defaults?.data(forKey: AppGroupConstants.selectedAppsKey),
           let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            store.shield.applications = selection.applicationTokens
        }
    }
}

extension DeviceActivityEvent.Name {
    static let usageThresholdReached = Self("com.focusshield.usage.threshold")
}

extension DeviceActivityName {
    static let dailyUsage = Self("com.focusshield.daily.usage")
}

enum AppGroupConstants {
    static let suiteName = "group.com.focusshield.shared"
    static let todosKey = "todos"
    static let settingsKey = "usageSettings"
    static let selectedAppsKey = "selectedApps"
}
