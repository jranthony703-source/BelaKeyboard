#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Building Sawt Keyboard..."
xcodebuild -scheme SawtKeyboard -destination 'generic/platform=iOS Simulator' -quiet build

echo "==> Checking required files..."
required=(
  "Shared/AppGroupNotifier.swift"
  "SawtKeyboardExtension/assets/tigrinya_words.txt"
  "SawtKeyboard/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
  "SawtKeyboard/Configuration.storekit"
)
for f in "${required[@]}"; do
  [[ -f "$f" ]] || { echo "Missing: $f"; exit 1; }
done

WORD_COUNT=$(wc -l < SawtKeyboardExtension/assets/tigrinya_words.txt | tr -d ' ')
if [[ "$WORD_COUNT" -lt 100 ]]; then
  echo "Word list should have at least 100 lines (found $WORD_COUNT)"
  exit 1
fi

echo "==> All checks passed."
