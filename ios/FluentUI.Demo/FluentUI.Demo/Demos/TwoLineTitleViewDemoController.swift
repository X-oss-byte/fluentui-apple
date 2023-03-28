//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TwoLineTitleViewDemoController: DemoController {
    private typealias UINavigationItemModifier = (UINavigationItem) -> Void
    private typealias TwoLineTitleViewFactory = () -> TwoLineTitleView

    private static func createDemoTitleView() -> TwoLineTitleView {
        let twoLineTitleView = TwoLineTitleView()

        // Give it a visible margin so we can confirm it centers properly
        twoLineTitleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        twoLineTitleView.layer.borderWidth = GlobalTokens.stroke(.width10)
        twoLineTitleView.layer.borderColor = GlobalTokens.neutralColor(.grey50).cgColor

        return twoLineTitleView
    }

    // Return a function that returns the title view because we may end up calling it multiple times in case of bottom sheets
    private static func makeStandardTitleView(title: String,
                                              titleImage: UIImage? = nil,
                                              subtitle: String? = nil,
                                              alignment: TwoLineTitleView.Alignment = .center,
                                              interactivePart: TwoLineTitleView.InteractivePart = .none,
                                              animatesWhenPressed: Bool = true,
                                              accessoryType: TwoLineTitleView.AccessoryType = .none) -> TwoLineTitleViewFactory {
        return {
            let twoLineTitleView = createDemoTitleView()
            twoLineTitleView.setup(title: title,
                                   titleImage: titleImage,
                                   subtitle: subtitle,
                                   alignment: alignment,
                                   interactivePart: interactivePart,
                                   animatesWhenPressed: animatesWhenPressed,
                                   accessoryType: accessoryType)
            return twoLineTitleView
        }
    }

    private static func makeExampleNavigationItem(_ initializer: UINavigationItemModifier) -> UINavigationItem {
        let navigationItem = UINavigationItem()
        initializer(navigationItem)
        return navigationItem
    }

    private static func makeNavigationTitleView(_ navigationItemModifier: UINavigationItemModifier) -> TwoLineTitleView {
        let twoLineTitleView = createDemoTitleView()

        let aNavigationItem = UINavigationItem()
        navigationItemModifier(aNavigationItem)

        twoLineTitleView.setup(navigationItem: aNavigationItem)

        return twoLineTitleView
    }

    private let exampleSetupFactories: [TwoLineTitleViewFactory] = [
        makeStandardTitleView(title: "Title here", subtitle: "Optional subtitle", animatesWhenPressed: false),
        makeStandardTitleView(title: "Custom image", titleImage: UIImage(named: "ic_fluent_star_16_regular"), animatesWhenPressed: false),
        makeStandardTitleView(title: "This one", subtitle: "can be tapped", interactivePart: .all),
        makeStandardTitleView(title: "All the bells", titleImage: UIImage(named: "ic_fluent_star_16_regular"), subtitle: "and whistles", alignment: .leading, interactivePart: .subtitle, accessoryType: .downArrow)
    ]

    private let exampleNavigationItems: [UINavigationItem] = [
        makeExampleNavigationItem {
            $0.title = "Title here"
        },
        makeExampleNavigationItem {
            $0.title = "Another title"
            $0.subtitle = "With a subtitle"
        },
        makeExampleNavigationItem {
            $0.title = "This one"
            $0.subtitle = "has an image"
            $0.titleImage = UIImage(named: "ic_fluent_star_16_regular")
        },
        makeExampleNavigationItem {
            $0.title = "This one"
            $0.subtitle = "has a disclosure chevron"
            $0.titleAccessory = .init(location: .title, style: .disclosure)
        },
        makeExampleNavigationItem {
            $0.title = "They can also be"
            $0.subtitle = "leading-aligned"
            $0.usesLargeTitle = true
        }
    ]

    private var allExamples: [TwoLineTitleView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "TwoLineTitleView is intended to be used in a navigation bar or the title of a sheet. It features the ability to show custom icons, a disclosure chevron, and other things.\n\nYou can also populate a bottom sheet with a TwoLineTitleView."

        container.alignment = .leading

        addTitle(text: "Made by calling TwoLineTitleView.setup(...)")
        exampleSetupFactories.enumerated().forEach {
            (offset, element) in
            let twoLineTitleView = element()
            allExamples.append(twoLineTitleView)

            let button = Button()
            button.tag = offset
            button.setTitle("Show", for: .normal)
            button.addTarget(self, action: #selector(setupButtonWasTapped), for: .primaryActionTriggered)

            addRow(items: [twoLineTitleView, button])
        }

        addTitle(text: "Made from UINavigationItem")
        exampleNavigationItems.enumerated().forEach {
            (offset, navigationItem) in
            let twoLineTitleView = Self.createDemoTitleView()
            twoLineTitleView.setup(navigationItem: navigationItem)
            allExamples.append(twoLineTitleView)

            let button = Button()
            button.tag = offset
            button.setTitle("Show", for: .normal)
            button.addTarget(self, action: #selector(navigationButtonWasTapped), for: .primaryActionTriggered)

            addRow(items: [twoLineTitleView, button])
        }
    }

    @objc private func navigationButtonWasTapped(sender: UIButton) {
        let titleView = TwoLineTitleView()
        titleView.setup(navigationItem: exampleNavigationItems[sender.tag])
        showBottomSheet(with: titleView)
    }

    @objc private func setupButtonWasTapped(sender: UIButton) {
        let titleView = exampleSetupFactories[sender.tag]()
        showBottomSheet(with: titleView)
    }

    private func showBottomSheet(with titleView: TwoLineTitleView) {
        let sheetContentView = UIView()

        // This is the bottom sheet that will temporarily be displayed after tapping the "Show transient sheet" button.
        // There can be multiple of these on screen at the same time. All the currently presented transient sheets
        // are tracked in presentedTransientSheets.
        let secondarySheetController = BottomSheetController(headerContentView: titleView, expandedContentView: sheetContentView)
        secondarySheetController.collapsedContentHeight = 100
        secondarySheetController.isHidden = true
        secondarySheetController.shouldAlwaysFillWidth = false
        secondarySheetController.shouldHideCollapsedContent = false
        secondarySheetController.isFlexibleHeight = true
        secondarySheetController.allowsSwipeToHide = true

        let dismissButton = Button(primaryAction: UIAction(title: "Dismiss", handler: { _ in
            secondarySheetController.setIsHidden(true, animated: true)
        }))

        dismissButton.style = .accent
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        sheetContentView.addSubview(dismissButton)

        addChild(secondarySheetController)
        view.addSubview(secondarySheetController.view)
        secondarySheetController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            secondarySheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondarySheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondarySheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            secondarySheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: sheetContentView.leadingAnchor, constant: 18),
            dismissButton.trailingAnchor.constraint(equalTo: sheetContentView.trailingAnchor, constant: -18),
            dismissButton.bottomAnchor.constraint(equalTo: sheetContentView.safeAreaLayoutGuide.bottomAnchor)
        ])

        // We need to layout before unhiding to ensure the sheet controller
        // has a meaningful initial frame to use for the animation.
        view.layoutIfNeeded()
        secondarySheetController.isHidden = false
    }
}

extension TwoLineTitleViewDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: TwoLineTitleViewTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        allExamples.forEach {
            $0.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: TwoLineTitleViewTokenSet.self) != nil
    }

    private var themeWideOverrideTokens: [TwoLineTitleViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleColor: .uiColor { GlobalTokens.sharedColor(.green, .primary) },
            .subtitleColor: .uiColor { GlobalTokens.sharedColor(.red, .primary) }
        ]
    }

    private var perControlOverrideTokens: [TwoLineTitleViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleColor: .uiColor { GlobalTokens.sharedColor(.blue, .primary) },
            .titleFont: .uiFont { UIFont(descriptor: .init(name: "Papyrus", size: 12), size: 12) },
            .subtitleColor: .uiColor { GlobalTokens.sharedColor(.orange, .primary) },
            .subtitleFont: .uiFont { UIFont(descriptor: .init(name: "Papyrus", size: 10), size: 10) }
        ]
    }
}
