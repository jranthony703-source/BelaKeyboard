# App Store Submission Checklist — Bela ቤላ Keyboard

Step-by-step path from "code finished" to "live on the App Store."
Estimated first-submission time: **3–6 hours** spread over **1–3 days** (Apple review takes 24–48h).

---

## 0. What's already done in this repo ✅

- App icon master (1024×1024) in `AppIcon.appiconset`
- Privacy manifests (`PrivacyInfo.xcprivacy`) for app + extension, declaring `NSUserDefaults` Required Reason API
- Privacy Policy template → [`AppStore/PrivacyPolicy.md`](./PrivacyPolicy.md)
- Support page template → [`AppStore/SupportPage.md`](./SupportPage.md)
- App Store metadata draft → [`AppStore/metadata.json`](./metadata.json)
- Local StoreKit testing config (`Configuration.storekit`)
- Bundle IDs: `com.sawtKeyboard.app` / `.extension` / `group.com.sawtKeyboard.shared` / IAP `com.sawtKeyboard.premiumThemes`

---

## 1. Apple Developer Portal setup

Go to https://developer.apple.com/account/resources

### a. Register App IDs

For each of these, click **Identifiers** → **+** → **App IDs** → **App**:

| App ID | Capabilities to enable |
|---|---|
| `com.sawtKeyboard.app` | App Groups |
| `com.sawtKeyboard.app.extension` | App Groups |

### b. Register the App Group

**Identifiers** → **App Groups** → **+** → register:
- `group.com.sawtKeyboard.shared`

Then go back to each App ID and **edit App Groups**, ticking that group.

### c. Register the IAP product

This actually happens in App Store Connect (step 3), not the Developer Portal. Skip for now.

---

## 2. Host the Privacy Policy + Support URLs

Apple requires both URLs to be **live and publicly reachable** before submission.

### Easy free option: GitHub Pages on this repo

1. Push the repo (you already did — `https://github.com/jranthony703-source/BelaKeyboard`).
2. Repo Settings → **Pages** → **Build from a branch** → branch `main`, folder `/AppStore` → Save.
3. After ~1 minute, your URLs will be:
   - **Privacy Policy:** `https://jranthony703-source.github.io/BelaKeyboard/PrivacyPolicy`
   - **Support:** `https://jranthony703-source.github.io/BelaKeyboard/SupportPage`

> If your repo is **private**, GitHub Pages requires a paid plan. Either make the repo public, or buy/host on a domain you own (e.g. `belakeyboard.app`).

### After hosting, update the email and link in the code

The About section currently links to `https://belakeyboard.app/privacy` and `support@belakeyboard.app`. Update [`AboutSectionView.swift`](../SawtKeyboard/Views/AboutSectionView.swift) lines 41 and 47 to your real URLs once chosen.

---

## 3. App Store Connect — create the app

Go to https://appstoreconnect.apple.com → **My Apps** → **+ New App**

| Field | Value |
|---|---|
| Platforms | iOS |
| Name | **Bela Keyboard** (must be unique on App Store) |
| Primary language | English (US) — add Tigrinya translation later if available |
| Bundle ID | `com.sawtKeyboard.app` (select from dropdown) |
| SKU | `BELA-KEYBOARD-001` (internal, any string) |
| User Access | Full Access |

Click **Create**.

### Then on the new app's page, fill in:

**App Information**
- Subtitle: `Proper Tigrinya Ge'ez Keyboard` (max 30 chars)
- Category (primary): **Utilities**
- Category (secondary): **Productivity**
- Content rights: "I do not own/license third-party content"

**Pricing and Availability**
- Price: Free
- Availability: All countries (or restrict to Eritrea/Ethiopia/Diaspora regions if you prefer)

**App Privacy** (questionnaire — answer based on the [Privacy Policy](./PrivacyPolicy.md)):
- **Data collection?** → **No**
- (No follow-up questions needed because we collect nothing)

**Version 1.0 → Build section** (this stays empty until you upload from Xcode — step 5)

**Version 1.0 → App Information**
- Promotional text: copy from `metadata.json` → `promotionalText`
- Description: copy from `metadata.json` → `description`
- Keywords: `Tigrinya,Geez,Ethiopic,Eritrea,Bela,keyboard,ትግርኛ,ቤላ,Amharic`
- Support URL: your URL from step 2
- Marketing URL: optional
- Copyright: `2026 Antonyo S MICHAEL`
- Privacy Policy URL: your URL from step 2 (REQUIRED)

---

## 4. Register the In-App Purchase

In App Store Connect → your app → **In-App Purchases and Subscriptions** → **+**:

- Type: **Non-Consumable**
- Reference Name: `Premium Themes`
- Product ID: `com.sawtKeyboard.premiumThemes`
- Price: Tier 3 ($2.99 USD)
- Localization: add display name `Premium Themes` and description `Unlock 5 extra themes including Ocean, Forest, Night, Sand, and Eritrea.`
- Review screenshot: any screenshot of the premium theme grid (you'll add this when capturing screenshots)
- Review notes: `Tap "Unlock Premium Themes" on the home screen; test purchase via sandbox account.`

---

## 5. Build, archive, upload from Xcode

1. In Xcode: select **Any iOS Device (arm64)** as the run destination.
2. **Product → Archive**. This builds a release archive (~3–5 min).
3. When the Organizer opens: **Distribute App** → **App Store Connect** → **Upload** → follow the wizard.
4. After upload (10–30 min processing), the build appears in App Store Connect under **TestFlight → iOS Builds** and **App Store → Build**.

### Common errors

- **"Missing Push Notification Entitlement"** — N/A for keyboards. If it errors anyway, remove the push capability if present.
- **"Invalid Provisioning Profile"** — go back to Signing & Capabilities and let Xcode auto-manage signing.
- **"Missing Privacy Manifest API"** — make sure both `PrivacyInfo.xcprivacy` files are added to their respective targets' Copy Bundle Resources phase.

---

## 6. Screenshots

Apple requires screenshots for at least the **6.7" iPhone** size. 6.5" and 5.5" are optional but useful for older buyers.

| Size | Resolution | Required? | Device to capture from |
|---|---|---|---|
| 6.7" | 1290 × 2796 | **YES** | iPhone 15/16 Pro Max, iPhone 14/15/16 Plus |
| 6.5" | 1242 × 2688 | Optional | iPhone 11 / Xs Max / XR |
| 5.5" | 1242 × 2208 | Optional | iPhone 8 Plus |

You need **3–10 screenshots** per size.

### Suggested screenshot lineup (in order)

1. **Hero** — Messages app open, typing a Tigrinya greeting like "ሰላም ከመይ ኣለኻ" with the Bela keyboard visible
2. **Vowel popup** — Tap-and-hold on a consonant showing the 7 vowel forms
3. **Suggestion bar** — typing in Tigrinya with word suggestions visible
4. **Emoji keyboard** — emoji grid with a category selected
5. **Theme picker** — settings screen showing the theme grid with a premium theme highlighted
6. **About screen** — showing the creator credit
7. **Premium unlock** — premium section in the settings

### How to capture

1. Run the app on a 6.7" iPhone (or simulator: **Xcode → Window → Devices and Simulators → +** → choose iPhone 15 Pro Max).
2. Set up each scene.
3. On device: press **Volume Up + Side button**. Screenshots go to Photos.
4. AirDrop to Mac. Or for Simulator: ⌘S saves to Desktop.
5. Crop / verify the size — must be exactly **1290 × 2796 px** for 6.7".
6. Upload in App Store Connect → your app → version 1.0 → drag in.

> **Tip:** Use **iOS Simulator** for clean status-bar shots. Run `xcrun simctl status_bar booted override --time "9:41" --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3` before each capture to get the Apple-standard top bar.

---

## 7. Review notes for Apple

In App Store Connect → version 1.0 → **App Review Information**:

```
The reviewer should:

1. Open the Bela Keyboard app.
2. Tap "Open Keyboard Settings" to enable the keyboard in Settings → General → Keyboard → Keyboards → Bela Keyboard.
3. Return to any text field (Notes, Messages).
4. Tap and hold the 🌐 globe icon, choose "Bela Keyboard".
5. Type using the Ge'ez consonant grid; tap any base character to see its vowel popup.
6. Try the 😀 emoji button and the 123 / ABC mode switches.

Bela Keyboard does NOT request "Allow Full Access". It performs no network requests
and stores no user-typed content anywhere. All preferences (theme, language, IAP
unlock state) are kept in App Group UserDefaults on-device only.

Premium Themes IAP testing:
- Tap "Unlock Premium Themes — $2.99" in the home screen.
- Use a sandbox test account. After purchase the premium swatches in the theme
  picker unlock immediately, including the keyboard extension on next open.

Demo account: not required (no login).
```

---

## 8. TestFlight (recommended before public release)

1. After the build finishes processing, go to **TestFlight** tab.
2. Add yourself + 2-5 trusted testers under **Internal Testing**.
3. Submit for **Beta App Review** (faster than App Store review).
4. Testers install via the **TestFlight app**.
5. Use real devices to verify the keyboard switches, themes apply, IAP works in sandbox.

---

## 9. Submit for review

When you're ready:

1. In App Store Connect, version 1.0 → confirm all required fields are green.
2. Click **Add for Review** → **Submit**.
3. Apple's review typically takes **24–48 hours**. First submissions sometimes take 3–5 days.

### Likely rejection reasons (and how to avoid them)

| Reason | Fix |
|---|---|
| Keyboard demo unclear to reviewer | Make review notes very explicit (above) |
| Privacy Policy URL 404 | Verify the URL is reachable from a browser before submitting |
| IAP not testable | Make sure the IAP product is "Ready to Submit" and attached to the build |
| App name claims "best/free/etc" | Avoid superlatives in metadata |
| Screenshots don't show app UI | Hero screenshot must show the actual keyboard, not just a logo |

---

## 10. After approval

- Set a **release date** (manual or automatic).
- Bump version + build number in Xcode for v1.1 (next release).
- Watch for crash reports in App Store Connect → Analytics.
- Reply to user reviews in App Store Connect → Ratings and Reviews.

---

## Bundle ID note

You may have noticed bundle IDs are still `com.sawtKeyboard.*` from the old "Sawt Keyboard" name. **Don't change these** unless you absolutely have to — the display name "Bela Keyboard" is what users see. Renaming bundle IDs would require:
- New App IDs in Developer Portal
- New App Group
- New IAP product
- Re-do all provisioning
- Lose your existing TestFlight build history

If you ever do want a clean rename for v2.0, ask for help when the time comes.

---

© 2026 Antonyo S MICHAEL. All rights reserved.
