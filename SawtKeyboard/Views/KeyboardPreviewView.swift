import SwiftUI

/// A live, interactive miniature of the real keyboard that renders with the
/// selected theme and language. Tapping keys types into a sample chat bubble
/// and shows the Ge'ez vowel popup — exactly like the real keyboard.
struct KeyboardPreviewView: View {
    let theme: Theme
    let language: KeyboardLanguage

    @State private var typed: String = "ሰላም "
    @State private var activeConsonant: GeezConsonant?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 8)

    /// First 24 consonants → a compact 3×8 grid for the preview.
    private var sampleConsonants: [GeezConsonant] {
        Array(GeezConsonant.allCases.prefix(24))
    }

    private var suggestions: [String] {
        switch language {
        case .tigrinya: return ["ሰላም", "ከመይ", "የቐንየለይ"]
        case .tigre:    return ["ሰላም", "ከፎ", "ጽቡቕ"]
        case .amharic:  return ["ሰላም", "እንዴት", "አመሰግናለሁ"]
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            chatArea
            keyboardArea
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.28), radius: 16, x: 0, y: 10)
        .animation(.easeInOut(duration: 0.25), value: theme.id)
    }

    // MARK: - Chat area

    private var chatArea: some View {
        VStack(spacing: 6) {
            HStack {
                Spacer(minLength: 40)
                Text(typed.isEmpty ? "​" : typed)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 9)
                    .background(
                        Brand.primaryGradient,
                        in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                    )
            }
        }
        .frame(maxWidth: .infinity, minHeight: 76, alignment: .bottom)
        .padding(10)
        .background(Color(.systemGray6))
    }

    // MARK: - Keyboard area

    private var keyboardArea: some View {
        VStack(spacing: 5) {
            suggestionBar
            consonantGrid
            toolbar
        }
        .padding(.vertical, 7)
        .background(theme.keyboardBackground)
        .overlay(alignment: .top) {
            if let consonant = activeConsonant {
                vowelPopup(consonant)
                    .padding(.top, 34)
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
            }
        }
    }

    private var suggestionBar: some View {
        HStack(spacing: 6) {
            ForEach(suggestions, id: \.self) { word in
                Button {
                    append(word + " ")
                } label: {
                    Text(word)
                        .font(.system(size: 13))
                        .foregroundColor(theme.keyText)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(theme.keyBackground)
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 6)
        .frame(maxWidth: .infinity, minHeight: 28)
        .background(theme.suggestionBarBackground)
    }

    private var consonantGrid: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(sampleConsonants) { consonant in
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                        activeConsonant = consonant
                    }
                    AppHaptics.tap(.light)
                } label: {
                    Text(consonant.baseCharacter)
                        .font(.system(size: 17))
                        .foregroundColor(theme.keyText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(theme.keyBackground)
                        .cornerRadius(5)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 6)
    }

    private var toolbar: some View {
        HStack(spacing: 4) {
            fixedKey("🌐") {}
            fixedKey(language.shortLabel) {}
            fixedKey("123") {}
            Button {
                append(" ")
            } label: {
                Text(Strings.Keyboard.space)
                    .font(.system(size: 12))
                    .foregroundColor(theme.keyText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .background(theme.specialKeyBackground)
                    .cornerRadius(5)
            }
            .buttonStyle(.plain)
            fixedKey("⌫") { deleteLast() }
        }
        .padding(.horizontal, 6)
    }

    private func fixedKey(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(theme.keyText)
                .frame(width: 36, height: 30)
                .background(theme.specialKeyBackground)
                .cornerRadius(5)
        }
        .buttonStyle(.plain)
    }

    private func vowelPopup(_ consonant: GeezConsonant) -> some View {
        HStack(spacing: 3) {
            ForEach(Array(consonant.vowelForms.enumerated()), id: \.offset) { _, form in
                Button {
                    append(form)
                    withAnimation(.easeOut(duration: 0.15)) { activeConsonant = nil }
                } label: {
                    Text(form)
                        .font(.system(size: 18))
                        .foregroundColor(theme.keyText)
                        .frame(width: 30, height: 38)
                        .background(theme.popupBackground)
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .background(theme.popupBackground.opacity(0.97))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }

    // MARK: - Editing

    private func append(_ string: String) {
        if typed.count > 36 { typed = "" }
        typed += string
        AppHaptics.tap(.light)
    }

    private func deleteLast() {
        guard !typed.isEmpty else { return }
        typed.removeLast()
        AppHaptics.tap(.light)
    }
}
