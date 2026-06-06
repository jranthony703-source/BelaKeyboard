import SwiftUI

struct KeyboardRootView: View {
    @ObservedObject var state: KeyboardState
    let onInsertText: (String) -> Void
    let onDeleteBackward: () -> Void
    let onAdvanceInputMode: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                SuggestionBarView(
                    suggestions: state.suggestions,
                    theme: state.theme,
                    onSelect: { word in
                        state.applySuggestion(word, onInsert: onInsertText, onDelete: onDeleteBackward)
                    }
                )

                ZStack(alignment: .bottom) {
                    keyboardContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    if let consonant = state.activePopup {
                        VowelPopupView(
                            consonant: consonant,
                            theme: state.theme,
                            onSelect: { form in
                                state.insertCharacter(form, onInsert: onInsertText)
                            },
                            onDismiss: {
                                state.dismissPopup(insertBase: true, onInsert: onInsertText)
                            }
                        )
                        .padding(.bottom, 52)
                        .transition(.opacity)
                    }
                }

                ToolbarView(
                    language: state.language,
                    theme: state.theme,
                    mode: state.mode,
                    onGlobe: onAdvanceInputMode,
                    onLanguageToggle: { state.cycleLanguage() },
                    onNumbers: { state.mode = .numbers },
                    onLatin: { state.mode = .latin },
                    onGeez: { state.mode = .geez },
                    onEmoji: { state.mode = .emoji },
                    onSpace: { state.insertSpace(onInsert: onInsertText) },
                    onReturn: { state.insertReturn(onInsert: onInsertText) },
                    onBackspace: { state.handleBackspace(onDelete: onDeleteBackward) }
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(state.theme.keyboardBackground)
        }
        .background(state.theme.keyboardBackground)
    }

    @ViewBuilder
    private var keyboardContent: some View {
        switch state.mode {
        case .geez:
            GeezGridView(
                theme: state.theme,
                activeConsonant: state.activePopup,
                onConsonantTap: { state.showPopup(for: $0) },
                onBackgroundTap: {
                    if state.activePopup != nil {
                        state.dismissPopup(insertBase: true, onInsert: onInsertText)
                    }
                }
            )
        case .latin:
            LatinKeyboardView(
                theme: state.theme,
                onInsert: { state.insertCharacter($0, onInsert: onInsertText) },
                onBackspace: { state.handleBackspace(onDelete: onDeleteBackward) }
            )
        case .numbers:
            NumberPadView(
                theme: state.theme,
                onInsert: { state.insertCharacter($0, onInsert: onInsertText) },
                onBack: { state.mode = .geez }
            )
        case .emoji:
            EmojiKeyboardView(
                theme: state.theme,
                onInsert: { state.insertCharacter($0, onInsert: onInsertText) }
            )
        }
    }
}
