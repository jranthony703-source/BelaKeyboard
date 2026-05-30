import SwiftUI

struct PremiumSectionView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(icon: "crown.fill", title: Strings.Premium.sectionTitle)

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.95, green: 0.72, blue: 0.20), Color(red: 0.82, green: 0.55, blue: 0.10)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.orange.opacity(0.35), radius: 6, y: 3)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Premium Themes")
                            .font(.subheadline.weight(.semibold))
                        Text(Strings.Premium.subtext)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }

                Button {
                    Task { await purchaseManager.purchase() }
                } label: {
                    HStack {
                        if purchaseManager.isLoading {
                            ProgressView().tint(.white)
                        }
                        Text(displayPrice)
                            .font(.subheadline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .disabled(purchaseManager.isPremiumUnlocked || purchaseManager.isLoading)

                Button(Strings.Premium.restore) {
                    Task { await purchaseManager.restorePurchases() }
                }
                .font(.footnote)
                .disabled(purchaseManager.isLoading)

                if purchaseManager.isPremiumUnlocked {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                        Text(Strings.Premium.purchaseSuccess)
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundColor(.green)
                    .padding(.top, 4)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }

    private var displayPrice: String {
        if purchaseManager.isPremiumUnlocked {
            return Strings.Premium.purchaseSuccess
        }
        if let product = purchaseManager.product {
            return "Unlock Premium — \(product.displayPrice)"
        }
        return Strings.Premium.unlockButton
    }
}
