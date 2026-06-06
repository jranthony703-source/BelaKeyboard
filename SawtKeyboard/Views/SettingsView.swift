import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State private var defaultLanguage = KeyboardLanguage.defaultLanguage
    @State private var keyboardEnabled: Bool?

    var body: some View {
        ZStack {
            AnimatedMeshBackground()

            ScrollView {
                VStack(spacing: 18) {
                    AppHeaderView()
                    SetupSectionView(keyboardEnabled: $keyboardEnabled)
                    livePreviewSection
                    ThemePickerView()
                    PremiumSectionView()
                    LanguageSectionView(selectedLanguage: $defaultLanguage)
                    AboutSectionView()
                }
                .padding(.horizontal)
                .padding(.bottom, 28)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            themeManager.refresh()
            defaultLanguage = KeyboardLanguage.defaultLanguage
        }
        .alert(
            Strings.App.name,
            isPresented: Binding(
                get: { purchaseManager.statusMessage != nil },
                set: { if !$0 { purchaseManager.statusMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(purchaseManager.statusMessage ?? "")
        }
    }

    private var livePreviewSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(icon: "sparkles", title: Strings.Preview.sectionTitle, tint: Brand.pink)

            KeyboardPreviewView(
                theme: themeManager.activeTheme,
                language: defaultLanguage
            )

            HStack(spacing: 6) {
                Image(systemName: "hand.tap.fill")
                    .font(.caption2)
                Text(String(format: Strings.Preview.hint, themeManager.activeTheme.name))
                    .font(.caption)
            }
            .foregroundColor(.secondary)
        }
        .glassCard()
    }
}
