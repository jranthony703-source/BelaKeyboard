import Foundation

/// Prefix-matches typed Ge'ez text against the bundled word list.
final class WordSuggestionEngine {
    private let words: [String]

    init() {
        words = Self.loadWords()
    }

    func suggestions(for prefix: String, limit: Int) -> [String] {
        guard !prefix.isEmpty else { return [] }
        return words
            .filter { $0.hasPrefix(prefix) && $0 != prefix }
            .prefix(limit)
            .map { String($0) }
    }

    private static func loadWords() -> [String] {
        guard let url = Bundle.main.url(forResource: "tigrinya_words", withExtension: "txt", subdirectory: "assets")
              ?? Bundle.main.url(forResource: "tigrinya_words", withExtension: "txt"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return []
        }
        return content
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
