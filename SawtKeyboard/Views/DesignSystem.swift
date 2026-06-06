import SwiftUI
import UIKit

// MARK: - Brand palette

enum Brand {
    static let violet = Color(hex: "#7C5CFF")
    static let indigo = Color(hex: "#4B2EDB")
    static let pink   = Color(hex: "#FF5CA8")
    static let teal   = Color(hex: "#1FD1B6")
    static let gold   = Color(hex: "#FFC24B")

    static let primaryGradient = LinearGradient(
        colors: [violet, indigo],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldGradient = LinearGradient(
        colors: [Color(hex: "#FFD66B"), Color(hex: "#E0992B")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Animated gradient background

/// Soft, slowly drifting color blobs behind a translucent glass UI.
struct AnimatedMeshBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Color(.systemBackground)

            blob(Brand.violet, size: 380, x: animate ? -130 : -90,  y: animate ? -300 : -240)
            blob(Brand.pink,   size: 330, x: animate ?  160 : 110,  y: animate ? -160 : -220)
            blob(Brand.teal,   size: 340, x: animate ? -120 : -160, y: animate ?  330 : 280)
            blob(Brand.indigo, size: 320, x: animate ?  150 : 120,  y: animate ?  310 : 370)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }

    private func blob(_ color: Color, size: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .opacity(0.45)
            .blur(radius: 90)
            .offset(x: x, y: y)
    }
}

// MARK: - Glass card

struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 24
    var padding: CGFloat = 18

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.55), .white.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.14), radius: 20, x: 0, y: 12)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 24, padding: CGFloat = 18) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
}

// MARK: - Section header

struct SectionHeader: View {
    let icon: String
    let title: String
    var tint: Color = Brand.violet

    var body: some View {
        HStack(spacing: 11) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(tint.gradient, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: tint.opacity(0.4), radius: 6, y: 3)

            Text(title)
                .font(.system(.headline, design: .rounded))

            Spacer()
        }
    }
}

// MARK: - Buttons

struct GradientButtonStyle: ButtonStyle {
    var gradient: LinearGradient = Brand.primaryGradient
    var glowColor: Color = Brand.violet

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, design: .rounded).weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(gradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: glowColor.opacity(0.45), radius: 10, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, design: .rounded).weight(.medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Haptics (host app — Full Access not required here)

enum AppHaptics {
    static func tap(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
