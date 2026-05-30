import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State private var defaultLanguage = KeyboardLanguage.defaultLanguage
    @State private var keyboardEnabled: Bool?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AppHeaderView()
                SetupSectionView(keyboardEnabled: $keyboardEnabled)
                ThemePickerView()
                PremiumSectionView()
                LanguageSectionView(selectedLanguage: $defaultLanguage)
                AboutSectionView()
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color.accentColor.opacity(0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle(Strings.App.name)
        .navigationBarTitleDisplayMode(.inline)
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
}
