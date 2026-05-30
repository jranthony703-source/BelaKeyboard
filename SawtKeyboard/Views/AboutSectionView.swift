import SwiftUI
import UIKit

struct AboutSectionView: View {
    @Environment(\.openURL) private var openURL
    @State private var showShareSheet = false

    private var versionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(icon: "person.crop.circle.fill", title: Strings.About.sectionTitle)

            VStack(spacing: 12) {
                creatorCard

                VStack(spacing: 0) {
                    aboutRow(icon: "star.fill", iconColor: .yellow, title: Strings.About.rate) {
                        openAppStoreReview()
                    }
                    Divider().padding(.leading, 44)

                    aboutRow(icon: "square.and.arrow.up.fill", iconColor: .accentColor, title: Strings.About.share) {
                        showShareSheet = true
                    }
                    Divider().padding(.leading, 44)

                    aboutRow(icon: "lock.shield.fill", iconColor: .green, title: Strings.About.privacy) {
                        if let url = URL(string: "https://belakeyboard.app/privacy") {
                            openURL(url)
                        }
                    }
                    Divider().padding(.leading, 44)

                    aboutRow(icon: "envelope.fill", iconColor: .blue, title: Strings.About.contact) {
                        if let url = URL(string: "mailto:support@belakeyboard.app") {
                            openURL(url)
                        }
                    }
                }
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)

                Text(Strings.About.copyright)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [Strings.About.shareMessage])
        }
    }

    private var creatorCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                Text("AM")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(Strings.About.creator)
                    .font(.subheadline.weight(.semibold))
                Text("\(Strings.About.version) \(versionString)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.accentColor)
                .font(.title3)
        }
        .padding(12)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(10)
    }

    private func aboutRow(icon: String, iconColor: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(iconColor)
                    .cornerRadius(7)

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }

    private func openAppStoreReview() {
        // TODO: Replace with real App Store ID after first submission
        let appID = "0000000000"
        if let url = URL(string: "itms-apps://apps.apple.com/app/id\(appID)?action=write-review") {
            openURL(url)
        }
    }
}

struct SectionHeader: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.accentColor)
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
