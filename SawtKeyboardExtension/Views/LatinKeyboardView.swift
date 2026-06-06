import SwiftUI

/// iOS-authentic QWERTY layout for Latin transliteration input.
struct LatinKeyboardView: View {
    let theme: Theme
    let onInsert: (String) -> Void
    let onBackspace: () -> Void

    @State private var shiftState: ShiftState = .off
    @State private var lastShiftTap = Date.distantPast

    enum ShiftState {
        case off, on, locked

        var isActive: Bool { self != .off }

        var symbol: String {
            switch self {
            case .off: return "shift"
            case .on: return "shift.fill"
            case .locked: return "capslock.fill"
            }
        }
    }

    private let row1 = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
    private let row2 = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
    private let row3 = ["z", "x", "c", "v", "b", "n", "m"]

    private let spacing: CGFloat = 6
    private let outerPad: CGFloat = 4

    var body: some View {
        GeometryReader { geo in
            let available = geo.size.width - outerPad * 2
            let keyWidth = (available - spacing * 9) / 10
            let sideWidth = keyWidth * 1.5 + spacing * 0.5

            VStack(spacing: 10) {
                Spacer(minLength: 0)

                // Row 1 — full width, 10 keys
                HStack(spacing: spacing) {
                    ForEach(row1, id: \.self) { letterKey($0, width: keyWidth) }
                }

                // Row 2 — 9 keys, centered (home-row inset)
                HStack(spacing: spacing) {
                    Spacer(minLength: 0)
                    ForEach(row2, id: \.self) { letterKey($0, width: keyWidth) }
                    Spacer(minLength: 0)
                }

                // Row 3 — shift + 7 keys + backspace
                HStack(spacing: spacing) {
                    shiftKey(width: sideWidth)
                    ForEach(row3, id: \.self) { letterKey($0, width: keyWidth) }
                    BackspaceKeyButton(theme: theme, onDelete: onBackspace)
                        .frame(width: sideWidth)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, outerPad)
            .padding(.vertical, 6)
        }
    }

    // MARK: - Keys

    private func letterKey(_ key: String, width: CGFloat) -> some View {
        Button {
            onInsert(display(key))
            if shiftState == .on { shiftState = .off }   // auto-unshift after one capital
        } label: {
            Text(display(key))
                .font(.system(size: 22, weight: .regular))
        }
        .buttonStyle(PressableKeyStyle(theme: theme, popLabel: display(key)))
        .frame(width: width)
    }

    private func shiftKey(width: CGFloat) -> some View {
        Button(action: toggleShift) {
            Image(systemName: shiftState.symbol)
                .font(.system(size: 18, weight: .medium))
        }
        .buttonStyle(
            PressableKeyStyle(
                theme: theme,
                isSpecial: true,
                isHighlighted: shiftState.isActive,
                hapticStrength: .medium
            )
        )
        .frame(width: width)
    }

    // MARK: - Logic

    private func toggleShift() {
        let now = Date()
        let isDoubleTap = now.timeIntervalSince(lastShiftTap) < 0.3
        lastShiftTap = now

        if isDoubleTap {
            shiftState = .locked
            return
        }
        shiftState = (shiftState == .off) ? .on : .off
    }

    private func display(_ key: String) -> String {
        shiftState == .off ? key : key.uppercased()
    }
}
