# BELA ቤላ KEYBOARD

**Bela Keyboard** is a native iOS Ge'ez/Tigrinya keyboard with SwiftUI settings, theme picker, word suggestions, and StoreKit 2 premium themes.

**Created by Antonyo S MICHAEL.**

Tagline: **ብቑዕ ትግርኛ ፊደል** — The Proper Tigrinya Keyboard

---

## Project Structure

```
SawtKeyboard/
├── SawtKeyboard.xcodeproj
├── Shared/                          # Code shared by app + extension
│   ├── GeezConsonant.swift          # Ethiopic Unicode syllable logic
│   ├── KeyboardLanguage.swift
│   ├── SharedDefaults.swift         # App Group UserDefaults
│   ├── Strings.swift
│   ├── Theme.swift
│   └── ThemeManager.swift
├── SawtKeyboard/                    # Main app target
│   ├── SawtKeyboardApp.swift
│   ├── ContentView.swift
│   ├── Views/
│   ├── Managers/PurchaseManager.swift
│   ├── Helpers/KeyboardStatusChecker.swift
│   ├── Assets.xcassets
│   ├── Configuration.storekit       # Local IAP testing
│   ├── Info.plist
│   └── SawtKeyboard.entitlements
└── SawtKeyboardExtension/           # Keyboard extension target
    ├── KeyboardViewController.swift
    ├── KeyboardState.swift
    ├── WordSuggestionEngine.swift
    ├── Views/
    ├── tigrinya_words.txt
    ├── Info.plist
    └── SawtKeyboardExtension.entitlements
```

---

## Requirements

- Xcode 15+
- iOS 16+ (iPhone only)
- Apple Developer account (for device testing and App Store)
- No third-party dependencies

---

## Open in Xcode

1. Open `SawtKeyboard/SawtKeyboard.xcodeproj` in Xcode.
2. Select the **SawtKeyboard** scheme.
3. Set your **Development Team** for both targets:
   - SawtKeyboard
   - SawtKeyboardExtension

---

## Configure App Groups

Both targets must share the same App Group:

**App Group ID:** `group.com.sawtKeyboard.shared`

### Steps

1. In Xcode, select the project → **SawtKeyboard** target → **Signing & Capabilities**.
2. Click **+ Capability** → **App Groups**.
3. Add `group.com.sawtKeyboard.shared` (or enable the checkbox if already in entitlements).
4. Repeat for the **SawtKeyboardExtension** target.
5. Ensure the App Group is registered in [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers/list/applicationGroup) for your Team ID.

Entitlements files are already included:

- `SawtKeyboard/SawtKeyboard.entitlements`
- `SawtKeyboardExtension/SawtKeyboardExtension.entitlements`

---

## StoreKit — Premium Themes IAP

**Product ID:** `com.sawtKeyboard.premiumThemes`  
**Type:** Non-consumable (one-time $2.99)

### Local testing

1. The scheme includes `Configuration.storekit` for sandbox purchases in Simulator.
2. Run the app → tap **Unlock Premium Themes**.
3. Complete the test purchase flow.

### App Store Connect setup

1. Go to [App Store Connect](https://appstoreconnect.apple.com) → your app → **In-App Purchases**.
2. Create a **Non-Consumable** product:
   - Reference Name: Premium Themes
   - Product ID: `com.sawtKeyboard.premiumThemes`
   - Price: $2.99 (Tier 3)
3. Add localization (display name + description).
4. Submit the IAP for review with your app binary.

After purchase, `premiumUnlocked` is saved to App Group UserDefaults and the keyboard extension unlocks premium themes immediately on next open.

---

## Install on Device for Testing

Keyboard extensions **cannot be fully tested in Simulator alone** — use a physical iPhone.

1. Connect your iPhone and select it as the run destination.
2. Build & Run (**SawtKeyboard** target).
3. On the device: **Settings → General → Keyboard → Keyboards → Add New Keyboard**.
4. Select **Bela Keyboard**.
5. (Optional) Enable **Allow Full Access** if you add network features later — not required for v1.
6. Open any app (Notes, Messages), tap the globe icon 🌐, and select **Bela Keyboard**.

Use **Check Status** in the app to verify the keyboard is enabled.

---

## Keyboard Features

| Feature | Description |
|---------|-------------|
| Ge'ez grid | 33 base consonants; tap for 7 vowel forms (Unicode base + 0…6) |
| Language toggle | Cycles Tigrinya → Tigre → Amharic (short labels: ትግ / አማ) |
| Numbers panel | 0–9 + Ethiopic punctuation and symbols |
| Suggestion bar | Prefix match against `tigrinya_words.txt` |
| Themes | 3 free + 5 premium (IAP) |
| Toolbar | 🌐 globe, language, 123, space, return, ⌫ |

Replace `SawtKeyboardExtension/assets/tigrinya_words.txt` with your full word list when ready.

---

## Validate locally

```bash
./scripts/validate.sh
```

## Already configured in this repo

- 1024×1024 app icon + in-app logo asset
- 100-word suggestion list structure
- StoreKit sandbox config (`Configuration.storekit`)
- Privacy manifests (app + extension)
- App Store copy template (`AppStore/metadata.json`)
- Live theme/premium sync (App Group + Darwin notifications)

---

## Submit to App Store

1. **App ID:** Register `com.sawtKeyboard.app` in Developer Portal.
2. **Extension ID:** Register `com.sawtKeyboard.app.extension`.
3. Enable App Groups on both App IDs.
4. Set your **Development Team** in Xcode for both targets.
5. Archive: **Product → Archive** → **Distribute App**.
6. Complete App Store Connect listing:
   - Screenshots (iPhone)
   - Privacy policy URL (required if collecting data; minimal for v1)
   - Keyboard extension privacy description
7. Submit IAP `com.sawtKeyboard.premiumThemes` with the app version.
8. Apple review notes: explain how to enable the keyboard in Settings.

---

## Bundle Identifiers

| Target | Bundle ID |
|--------|-----------|
| Main app | `com.sawtKeyboard.app` |
| Extension | `com.sawtKeyboard.app.extension` |
| App Group | `group.com.sawtKeyboard.shared` |
| IAP | `com.sawtKeyboard.premiumThemes` |

---

## License

Copyright © 2026 Antonyo S MICHAEL. All rights reserved.
