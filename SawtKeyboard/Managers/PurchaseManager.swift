import StoreKit

/// StoreKit 2 manager for the premium themes non-consumable IAP.
@MainActor
final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    static let premiumProductID = "com.sawtKeyboard.premiumThemes"

    @Published private(set) var product: Product?
    @Published private(set) var isPremiumUnlocked = false
    @Published private(set) var isLoading = false
    @Published var statusMessage: String?

    private var transactionListener: Task<Void, Never>?

    private init() {
        isPremiumUnlocked = SharedDefaults.bool(for: SharedDefaults.Key.premiumUnlocked)
        transactionListener = listenForTransactions()
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [Self.premiumProductID])
            product = products.first
        } catch {
            statusMessage = Strings.Premium.purchaseFailed
        }
    }

    func purchase() async {
        guard let product else {
            statusMessage = Strings.Premium.purchaseFailed
            return
        }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await handleVerifiedTransaction(transaction)
                    await transaction.finish()
                    statusMessage = Strings.Premium.purchaseSuccess
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            statusMessage = Strings.Premium.purchaseFailed
        }
    }

    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AppStore.sync()
            await syncEntitlements()
            statusMessage = isPremiumUnlocked
                ? Strings.Premium.restoreSuccess
                : Strings.Premium.restoreFailed
        } catch {
            statusMessage = Strings.Premium.restoreFailed
        }
    }

    func syncEntitlements() async {
        var unlocked = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.premiumProductID {
                unlocked = true
                break
            }
        }
        applyPremiumUnlock(unlocked)
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else { continue }
                if transaction.productID == PurchaseManager.premiumProductID {
                    await self?.handleVerifiedTransaction(transaction)
                }
                await transaction.finish()
            }
        }
    }

    private func handleVerifiedTransaction(_ transaction: Transaction) async {
        guard transaction.productID == Self.premiumProductID else { return }
        applyPremiumUnlock(true)
    }

    private func applyPremiumUnlock(_ unlocked: Bool) {
        isPremiumUnlocked = unlocked
        SharedDefaults.set(unlocked, for: SharedDefaults.Key.premiumUnlocked)
        ThemeManager.shared.setPremiumUnlocked(unlocked)
    }
}
