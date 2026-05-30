import SwiftUI

struct AppHeaderView: View {
    var body: some View {
        VStack(spacing: 14) {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 104, height: 104)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.accentColor.opacity(0.7), Color.accentColor.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.accentColor.opacity(0.25), radius: 14, x: 0, y: 8)
                .padding(.top, 4)

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(Strings.App.displayMark)
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.primary, .primary.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Text(Strings.App.geezMark)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.accentColor)
            }

            Text(Strings.App.subtitle)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .tracking(6)
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.accentColor.opacity(0.10))
                )

            VStack(spacing: 4) {
                Text(Strings.App.tagline)
                    .font(.system(size: 17, weight: .semibold))
                Text(Strings.App.taglineEnglish)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}
