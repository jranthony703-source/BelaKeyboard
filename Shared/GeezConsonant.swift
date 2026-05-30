import Foundation

/// Ge'ez syllable logic using the Ethiopic Unicode block (U+1200–U+137F).
///
/// Each consonant row occupies 7 consecutive code points representing the
/// standard vowel order: ä (0), u (1), i (2), a (3), e (4), ï (5), o (6).
/// Example: ሀ (U+1200) → ሀ ሁ ሂ ሃ ሄ ህ ሆ via base + offset.
enum GeezConsonant: CaseIterable, Identifiable {
    case ha, la, hha, ma, sa, ra, ssa, sha, qa, qha, ba, ta, cha, na, nya
    case a, ka, kha, wa, aa, za, zha, ya, da, ja, ga, gta, gcha, gpa, gsa
    case tsa, fa, pa

    var id: String { String(baseScalar.value, radix: 16) }

    /// The first (ä-form) scalar value for this consonant row.
    var baseScalar: Unicode.Scalar {
        switch self {
        case .ha: return Unicode.Scalar(0x1200)!
        case .la: return Unicode.Scalar(0x1208)!
        case .hha: return Unicode.Scalar(0x1210)!
        case .ma: return Unicode.Scalar(0x1218)!
        case .sa: return Unicode.Scalar(0x1220)!
        case .ra: return Unicode.Scalar(0x1228)!
        case .ssa: return Unicode.Scalar(0x1230)!
        case .sha: return Unicode.Scalar(0x1238)!
        case .qa: return Unicode.Scalar(0x1240)!
        case .qha: return Unicode.Scalar(0x1248)!
        case .ba: return Unicode.Scalar(0x1260)!
        case .ta: return Unicode.Scalar(0x1270)!
        case .cha: return Unicode.Scalar(0x1278)!
        case .na: return Unicode.Scalar(0x1290)!
        case .nya: return Unicode.Scalar(0x1298)!
        case .a: return Unicode.Scalar(0x12A0)!
        case .ka: return Unicode.Scalar(0x12A8)!
        case .kha: return Unicode.Scalar(0x12B0)!
        case .wa: return Unicode.Scalar(0x12C8)!
        case .aa: return Unicode.Scalar(0x12D0)!
        case .za: return Unicode.Scalar(0x12D8)!
        case .zha: return Unicode.Scalar(0x12E0)!
        case .ya: return Unicode.Scalar(0x12E8)!
        case .da: return Unicode.Scalar(0x12F0)!
        case .ja: return Unicode.Scalar(0x12F8)!
        case .ga: return Unicode.Scalar(0x1308)!
        case .gta: return Unicode.Scalar(0x1310)!
        case .gcha: return Unicode.Scalar(0x1318)!
        case .gpa: return Unicode.Scalar(0x1320)!
        case .gsa: return Unicode.Scalar(0x1328)!
        case .tsa: return Unicode.Scalar(0x1338)!
        case .fa: return Unicode.Scalar(0x1348)!
        case .pa: return Unicode.Scalar(0x1350)!
        }
    }

    var baseCharacter: String { String(baseScalar) }

    /// All 7 vowel forms: base + 0…6 within the Ethiopic block.
    var vowelForms: [String] {
        (0..<7).compactMap { offset in
            guard let scalar = Unicode.Scalar(baseScalar.value + UInt32(offset)) else { return nil }
            guard scalar.value >= 0x1200, scalar.value <= 0x137F else { return nil }
            return String(scalar)
        }
    }

    static let vowelLabels = ["ä", "u", "i", "a", "e", "ï", "o"]
}
