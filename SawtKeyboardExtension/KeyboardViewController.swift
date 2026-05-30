import UIKit
import SwiftUI

/// Hosts the SwiftUI keyboard and bridges to UIInputViewController.
final class KeyboardViewController: UIInputViewController {
    private var hostingController: UIHostingController<KeyboardRootView>?
    private var heightConstraint: NSLayoutConstraint?
    private let keyboardState = KeyboardState()

    private var preferredKeyboardHeight: CGFloat {
        let isLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        return isLandscape ? 220 : 300
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
        HapticManager.prepare()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardState.refreshSettings()
        updateHeightConstraint()
        HapticManager.prepare()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateHeightConstraint()
        })
    }

    private func setupKeyboardView() {
        let rootView = KeyboardRootView(
            state: keyboardState,
            onInsertText: { [weak self] text in self?.textDocumentProxy.insertText(text) },
            onDeleteBackward: { [weak self] in self?.textDocumentProxy.deleteBackward() },
            onAdvanceInputMode: { [weak self] in self?.advanceToNextInputMode() }
        )

        let host = UIHostingController(rootView: rootView)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear

        addChild(host)
        view.addSubview(host.view)
        host.didMove(toParent: self)

        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let height = view.heightAnchor.constraint(equalToConstant: preferredKeyboardHeight)
        height.priority = UILayoutPriority(999)
        height.isActive = true
        heightConstraint = height

        hostingController = host
    }

    private func updateHeightConstraint() {
        heightConstraint?.constant = preferredKeyboardHeight
    }
}

// MARK: - Haptic feedback

/// Lightweight haptic feedback for key presses.
/// Requires "Allow Full Access" in keyboard settings to fire on most iOS versions;
/// degrades silently to a no-op otherwise — no crash, no error.
enum HapticManager {
    enum Strength {
        case light
        case medium
        case rigid
    }

    private static let light = UIImpactFeedbackGenerator(style: .light)
    private static let medium = UIImpactFeedbackGenerator(style: .medium)
    private static let rigid = UIImpactFeedbackGenerator(style: .rigid)

    static func prepare() {
        light.prepare()
        medium.prepare()
        rigid.prepare()
    }

    static func tap(_ strength: Strength = .light) {
        switch strength {
        case .light: light.impactOccurred(intensity: 0.55)
        case .medium: medium.impactOccurred(intensity: 0.75)
        case .rigid: rigid.impactOccurred(intensity: 0.85)
        }
    }
}
