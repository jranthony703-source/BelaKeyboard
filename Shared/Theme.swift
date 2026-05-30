import SwiftUI

/// Visual theme for the keyboard and settings preview swatches.
struct Theme: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let isPremium: Bool
    let keyBackgroundHex: String
    let keyTextHex: String
    let keyboardBackgroundHex: String
    let suggestionBarBackgroundHex: String
    let popupBackgroundHex: String
    let specialKeyBackgroundHex: String

    var keyBackground: Color { Color(hex: keyBackgroundHex) }
    var keyText: Color { Color(hex: keyTextHex) }
    var keyboardBackground: Color { Color(hex: keyboardBackgroundHex) }
    var suggestionBarBackground: Color { Color(hex: suggestionBarBackgroundHex) }
    var popupBackground: Color { Color(hex: popupBackgroundHex) }
    var specialKeyBackground: Color { Color(hex: specialKeyBackgroundHex) }

    static let all: [Theme] = [light, dark, habesha, ocean, forest, sand, night, eritrea]

    static let light = Theme(
        id: "light", name: Strings.Theme.light, isPremium: false,
        keyBackgroundHex: "#FFFFFF", keyTextHex: "#1C1C1E",
        keyboardBackgroundHex: "#D1D3D9", suggestionBarBackgroundHex: "#E8E8ED",
        popupBackgroundHex: "#FFFFFF", specialKeyBackgroundHex: "#AEB3BC"
    )

    static let dark = Theme(
        id: "dark", name: Strings.Theme.dark, isPremium: false,
        keyBackgroundHex: "#3A3A3C", keyTextHex: "#FFFFFF",
        keyboardBackgroundHex: "#000000", suggestionBarBackgroundHex: "#1C1C1E",
        popupBackgroundHex: "#48484A", specialKeyBackgroundHex: "#636366"
    )

    static let habesha = Theme(
        id: "habesha", name: Strings.Theme.habesha, isPremium: false,
        keyBackgroundHex: "#6B3A2A", keyTextHex: "#D4AF37",
        keyboardBackgroundHex: "#8B1A1A", suggestionBarBackgroundHex: "#7A2222",
        popupBackgroundHex: "#5C2E1F", specialKeyBackgroundHex: "#4A2518"
    )

    static let ocean = Theme(
        id: "ocean", name: Strings.Theme.ocean, isPremium: true,
        keyBackgroundHex: "#0077B6", keyTextHex: "#FFFFFF",
        keyboardBackgroundHex: "#023E8A", suggestionBarBackgroundHex: "#034078",
        popupBackgroundHex: "#0096C7", specialKeyBackgroundHex: "#005F8A"
    )

    static let forest = Theme(
        id: "forest", name: Strings.Theme.forest, isPremium: true,
        keyBackgroundHex: "#6B9080", keyTextHex: "#FFFFFF",
        keyboardBackgroundHex: "#1B4332", suggestionBarBackgroundHex: "#2D6A4F",
        popupBackgroundHex: "#52796F", specialKeyBackgroundHex: "#40916C"
    )

    static let sand = Theme(
        id: "sand", name: Strings.Theme.sand, isPremium: true,
        keyBackgroundHex: "#D4A574", keyTextHex: "#4A3728",
        keyboardBackgroundHex: "#F5E6D3", suggestionBarBackgroundHex: "#EDD9C0",
        popupBackgroundHex: "#E8C9A8", specialKeyBackgroundHex: "#C4956A"
    )

    static let night = Theme(
        id: "night", name: Strings.Theme.night, isPremium: true,
        keyBackgroundHex: "#7B2CBF", keyTextHex: "#FFFFFF",
        keyboardBackgroundHex: "#240046", suggestionBarBackgroundHex: "#3C096C",
        popupBackgroundHex: "#9D4EDD", specialKeyBackgroundHex: "#5A189A"
    )

    static let eritrea = Theme(
        id: "eritrea", name: Strings.Theme.eritrea, isPremium: true,
        keyBackgroundHex: "#3A9952", keyTextHex: "#FFD700",
        keyboardBackgroundHex: "#1A5276", suggestionBarBackgroundHex: "#2471A3",
        popupBackgroundHex: "#2ECC71", specialKeyBackgroundHex: "#E74C3C"
    )

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? .light
    }
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
