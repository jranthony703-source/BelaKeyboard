import Foundation

/// Supported keyboard languages. All share the same Ge'ez grid in v1.
enum KeyboardLanguage: String, CaseIterable, Identifiable, Codable {
    case tigrinya
    case tigre
    case amharic

    var id: String { rawValue }

    var shortLabel: String {
        switch self {
        case .tigrinya: return Strings.Language.tigrinyaShort
        case .tigre: return Strings.Language.tigreShort
        case .amharic: return Strings.Language.amharicShort
        }
    }

    var displayName: String {
        switch self {
        case .tigrinya: return Strings.Language.tigrinya
        case .tigre: return Strings.Language.tigre
        case .amharic: return Strings.Language.amharic
        }
    }

    func next() -> KeyboardLanguage {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self) else { return .tigrinya }
        return all[(index + 1) % all.count]
    }

    static var saved: KeyboardLanguage {
        let raw = SharedDefaults.string(for: SharedDefaults.Key.lastLanguage)
            ?? SharedDefaults.string(for: SharedDefaults.Key.defaultLanguage)
        return KeyboardLanguage(rawValue: raw ?? "") ?? .tigrinya
    }

    static var defaultLanguage: KeyboardLanguage {
        let raw = SharedDefaults.string(for: SharedDefaults.Key.defaultLanguage)
        return KeyboardLanguage(rawValue: raw ?? "") ?? .tigrinya
    }

    func saveAsLastUsed() {
        SharedDefaults.set(rawValue, for: SharedDefaults.Key.lastLanguage)
    }

    func saveAsDefault() {
        SharedDefaults.set(rawValue, for: SharedDefaults.Key.defaultLanguage)
    }
}
