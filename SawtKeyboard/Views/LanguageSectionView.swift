import SwiftUI

struct LanguageSectionView: View {
    @Binding var selectedLanguage: KeyboardLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(icon: "globe", title: Strings.Language.sectionTitle)

            Picker(Strings.Language.sectionTitle, selection: $selectedLanguage) {
                ForEach(KeyboardLanguage.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedLanguage) { newValue in
                newValue.saveAsDefault()
            }

            Text("Pick the language shown on first keyboard launch.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}
