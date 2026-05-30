import SwiftUI
import Combine

/// Shared observable state for the keyboard extension UI.
final class KeyboardState: ObservableObject {
    @Published var language: KeyboardLanguage = .saved
    @Published var mode: KeyboardMode = .geez
    @Published var activePopup: GeezConsonant?
    @Published var theme: Theme = ThemeManager.shared.activeTheme
    @Published var suggestions: [String] = []
    @Published var currentWordPrefix: String = ""

    private let suggestionEngine = WordSuggestionEngine()
    private var cancellables = Set<AnyCancellable>()

    init() {
        ThemeManager.shared.$activeTheme
            .receive(on: DispatchQueue.main)
            .sink { [weak self] theme in self?.theme = theme }
            .store(in: &cancellables)

        AppGroupNotifier.startObserving(theme: { [weak self] in
            self?.refreshSettings()
        }, premium: { [weak self] in
            self?.refreshSettings()
        })
    }

    func refreshSettings() {
        ThemeManager.shared.refresh()
        language = KeyboardLanguage.saved
        theme = ThemeManager.shared.activeTheme
    }

    func cycleLanguage() {
        language = language.next()
        language.saveAsLastUsed()
    }

    func showPopup(for consonant: GeezConsonant) {
        activePopup = consonant
    }

    func dismissPopup(insertBase: Bool, onInsert: (String) -> Void) {
        if insertBase, let consonant = activePopup {
            onInsert(consonant.baseCharacter)
            trackCharacter(consonant.baseCharacter)
        }
        activePopup = nil
    }

    func insertCharacter(_ character: String, onInsert: (String) -> Void) {
        onInsert(character)
        trackCharacter(character)
        activePopup = nil
    }

    func insertSpace(onInsert: (String) -> Void) {
        onInsert(" ")
        currentWordPrefix = ""
        suggestions = []
    }

    func insertReturn(onInsert: (String) -> Void) {
        onInsert("\n")
        currentWordPrefix = ""
        suggestions = []
    }

    func handleBackspace(onDelete: () -> Void) {
        onDelete()
        if !currentWordPrefix.isEmpty {
            currentWordPrefix.removeLast()
            updateSuggestions()
        }
    }

    private func trackCharacter(_ character: String) {
        if character == " " || character == "\n" {
            currentWordPrefix = ""
            suggestions = []
            return
        }
        currentWordPrefix += character
        updateSuggestions()
    }

    private func updateSuggestions() {
        suggestions = suggestionEngine.suggestions(for: currentWordPrefix, limit: 3)
    }

    func applySuggestion(_ word: String, onInsert: (String) -> Void, onDelete: () -> Void) {
        let deleteCount = currentWordPrefix.count
        for _ in 0..<deleteCount { onDelete() }
        onInsert(word)
        onInsert(" ")
        currentWordPrefix = ""
        suggestions = []
    }
}

enum KeyboardMode {
    case geez
    case latin
    case numbers
}
