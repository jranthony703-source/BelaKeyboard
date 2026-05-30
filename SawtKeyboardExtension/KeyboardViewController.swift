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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardState.refreshSettings()
        updateHeightConstraint()
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
