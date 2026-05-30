import ManagedSettings
import ManagedSettingsUI
import UIKit
import Foundation

final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        let suggestion = loadRandomTodo()

        let subtitleText: String
        if let suggestion {
            subtitleText = "How about instead: \(suggestion)\n\nDo you REALLY REALLY REALLY need this app right now?"
        } else {
            subtitleText = "You've used up your daily limit.\n\nDo you REALLY REALLY REALLY need this app right now?"
        }

        return ShieldConfiguration(
            backgroundBlurStyle: .systemThickMaterial,
            backgroundColor: UIColor.systemBackground,
            icon: UIImage(systemName: "shield.checkered"),
            title: ShieldConfiguration.Label(
                text: "Time's Up!",
                color: UIColor.systemIndigo
            ),
            subtitle: ShieldConfiguration.Label(
                text: subtitleText,
                color: UIColor.label
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "I really need it",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor.systemRed,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "You're right, I'll do something else",
                color: UIColor.systemIndigo
            )
        )
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration(shielding: application)
    }

    override func configuration(
        shielding webDomain: WebDomain
    ) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .systemThickMaterial,
            title: ShieldConfiguration.Label(
                text: "Time's Up!",
                color: UIColor.systemIndigo
            ),
            subtitle: ShieldConfiguration.Label(
                text: "You've reached your daily limit.\nDo you REALLY REALLY REALLY need this right now?",
                color: UIColor.label
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "I really need it",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor.systemRed,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "You're right, I'll stop",
                color: UIColor.systemIndigo
            )
        )
    }

    private func loadRandomTodo() -> String? {
        guard let defaults = UserDefaults(suiteName: "group.com.focusshield.shared"),
              let data = defaults.data(forKey: "todos") else { return nil }

        struct TodoItem: Codable {
            let id: UUID
            var title: String
            var isCompleted: Bool
        }

        guard let todos = try? JSONDecoder().decode([TodoItem].self, from: data) else { return nil }
        return todos.filter { !$0.isCompleted }.randomElement()?.title
    }
}
