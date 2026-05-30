import SwiftUI

@main
struct SawtKeyboardApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var purchaseManager = PurchaseManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.loadProducts()
                    await purchaseManager.syncEntitlements()
                }
        }
    }
}
