import SwiftUI

struct ThemePickerView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(icon: "paintpalette.fill", title: Strings.Theme.sectionTitle)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Theme.all) { theme in
                    ThemeSwatchView(
                        theme: theme,
                        isActive: themeManager.activeTheme == theme,
                        isLocked: theme.isPremium && !themeManager.isPremiumUnlocked
                    ) {
                        if themeManager.canUse(theme) {
                            themeManager.setActiveTheme(theme)
                        }
                    }
                }
            }
        }
        .glassCard()
    }
}

struct ThemeSwatchView: View {
    let theme: Theme
    let isActive: Bool
    let isLocked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(theme.keyboardBackground)
                    .frame(height: 86)
                    .overlay(
                        HStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(theme.keyBackground)
                                .frame(width: 30, height: 30)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(theme.specialKeyBackground)
                                .frame(width: 30, height: 30)
                        }
                    )

                VStack {
                    Spacer()
                    HStack {
                        Text(theme.name)
                            .font(.caption.bold())
                            .foregroundColor(theme.keyText)
                        Spacer()
                        if isActive {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.subheadline)
                        }
                    }
                    .padding(8)
                    .background(theme.suggestionBarBackground.opacity(0.92))
                }

                if isLocked {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(0.48))
                    VStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.95, green: 0.72, blue: 0.20))
                        Text(Strings.Theme.locked)
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 86)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isActive ? Color.accentColor : Color.clear, lineWidth: 2.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
    }
}
