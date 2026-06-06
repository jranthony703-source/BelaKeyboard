import SwiftUI
import UIKit

struct SetupSectionView: View {
    @Binding var keyboardEnabled: Bool?
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(icon: "keyboard.fill", title: Strings.Setup.title)

            VStack(spacing: 10) {
                SetupStepView(number: 1, text: Strings.Setup.step1)
                SetupStepView(number: 2, text: Strings.Setup.step2)
                SetupStepView(number: 3, text: Strings.Setup.step3)
            }

            VStack(spacing: 8) {
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                } label: {
                    HStack {
                        Image(systemName: "gear")
                        Text(Strings.Setup.openSettings)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    keyboardEnabled = KeyboardStatusChecker.isKeyboardEnabled()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text(Strings.Setup.checkStatus)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 4)

            if let enabled = keyboardEnabled {
                HStack(spacing: 8) {
                    Image(systemName: enabled ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(enabled ? .green : .orange)
                    Text(enabled ? Strings.Setup.enabled : Strings.Setup.notEnabled)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(enabled ? .green : .orange)
                    Spacer()
                }
                .padding(10)
                .background((enabled ? Color.green : Color.orange).opacity(0.12))
                .cornerRadius(8)
            }
        }
        .glassCard()
    }
}

struct SetupStepView: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 26, height: 26)
                Text("\(number)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.accentColor)
            }
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
