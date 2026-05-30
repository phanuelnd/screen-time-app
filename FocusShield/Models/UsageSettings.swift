import Foundation
import FamilyControls
import ManagedSettings

struct UsageSettings: Codable {
    var dailyLimitMinutes: Int = 60
    var isMonitoringEnabled: Bool = false
    var lastResetDate: Date?

    static let defaultSettings = UsageSettings()
}

enum AppGroupConstants {
    static let suiteName = "group.com.focusshield.shared"
    static let todosKey = "todos"
    static let settingsKey = "usageSettings"
    static let selectedAppsKey = "selectedApps"
}
