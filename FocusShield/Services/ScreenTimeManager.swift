import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

@Observable
final class ScreenTimeManager {
    var isAuthorized = false
    var activitySelection = FamilyActivitySelection()
    var dailyLimitMinutes: Int = 60

    private let center = AuthorizationCenter.shared
    private let store = ManagedSettingsStore()
    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName) ?? .standard

    init() {
        loadSettings()
        isAuthorized = center.authorizationStatus == .approved
    }

    func requestAuthorization() async {
        do {
            try await center.requestAuthorization(for: .individual)
            isAuthorized = true
        } catch {
            isAuthorized = false
        }
    }

    func startMonitoring() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        let threshold = DateComponents(minute: dailyLimitMinutes)
        let event = DeviceActivityEvent(
            applications: activitySelection.applicationTokens,
            threshold: threshold
        )

        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(
                .dailyWhatsApp,
                during: schedule,
                events: [.whatsAppThresholdReached: event]
            )
            saveSettings()
        } catch {
            print("Failed to start monitoring: \(error)")
        }
    }

    func stopMonitoring() {
        let center = DeviceActivityCenter()
        center.stopMonitoring([.dailyWhatsApp])
        store.shield.applications = nil
    }

    func shieldSelectedApps() {
        store.shield.applications = activitySelection.applicationTokens.isEmpty
            ? nil
            : activitySelection.applicationTokens
    }

    func unshieldApps() {
        store.shield.applications = nil
    }

    func saveSelection() {
        guard let data = try? JSONEncoder().encode(activitySelection) else { return }
        defaults.set(data, forKey: AppGroupConstants.selectedAppsKey)
    }

    func loadSelection() {
        guard let data = defaults.data(forKey: AppGroupConstants.selectedAppsKey),
              let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) else { return }
        activitySelection = selection
    }

    private func saveSettings() {
        let settings = UsageSettings(
            dailyLimitMinutes: dailyLimitMinutes,
            isMonitoringEnabled: true,
            lastResetDate: .now
        )
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: AppGroupConstants.settingsKey)
    }

    private func loadSettings() {
        guard let data = defaults.data(forKey: AppGroupConstants.settingsKey),
              let settings = try? JSONDecoder().decode(UsageSettings.self, from: data) else { return }
        dailyLimitMinutes = settings.dailyLimitMinutes
    }
}

extension DeviceActivityName {
    static let dailyWhatsApp = Self("com.focusshield.daily.whatsapp")
}

extension DeviceActivityEvent.Name {
    static let whatsAppThresholdReached = Self("com.focusshield.whatsapp.threshold")
}
