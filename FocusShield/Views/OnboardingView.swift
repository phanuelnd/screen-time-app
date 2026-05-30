import SwiftUI

struct OnboardingView: View {
    @Environment(ScreenTimeManager.self) private var screenTimeManager

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "shield.checkered")
                .font(.system(size: 80))
                .foregroundStyle(.indigo)

            VStack(spacing: 12) {
                Text("FocusShield")
                    .font(.largeTitle.bold())

                Text("Take control of your screen time.\nWe'll help you spend less time on WhatsApp and more time on what matters.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "timer", color: .orange, title: "Track Usage", subtitle: "Monitor your daily WhatsApp time")
                FeatureRow(icon: "hand.raised.fill", color: .red, title: "Smart Shield", subtitle: "Blocks WhatsApp after your daily limit")
                FeatureRow(icon: "lightbulb.fill", color: .yellow, title: "Better Alternatives", subtitle: "Suggests activities from your TODO list")
            }
            .padding(.horizontal, 32)

            Spacer()

            Button {
                Task {
                    await screenTimeManager.requestAuthorization()
                }
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
