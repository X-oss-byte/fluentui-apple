//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class MSNavigationControllerDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Large Title with Primary style")
        container.addArrangedSubview(createButton(title: "Show without accessory", action: #selector(showLargeTitle)))
        container.addArrangedSubview(createButton(title: "Show with collapsible search bar", action: #selector(showLargeTitleWithShyAccessory)))
        container.addArrangedSubview(createButton(title: "Show with fixed search bar", action: #selector(showLargeTitleWithFixedAccessory)))
        container.addArrangedSubview(createButton(title: "Show without an avatar", action: #selector(showLargeTitleWithoutAvatar)))

        addTitle(text: "Large Title with System style")
        container.addArrangedSubview(createButton(title: "Show without accessory", action: #selector(showLargeTitleWithSystemStyle)))
        container.addArrangedSubview(createButton(title: "Show without accessory and shadow", action: #selector(showLargeTitleWithSystemStyleAndNoShadow)))
        container.addArrangedSubview(createButton(title: "Show with collapsible search bar", action: #selector(showLargeTitleWithSystemStyleAndShyAccessory)))
        container.addArrangedSubview(createButton(title: "Show with fixed search bar", action: #selector(showLargeTitleWithSystemStyleAndFixedAccessory)))

        addTitle(text: "Regular Title")
        container.addArrangedSubview(createButton(title: "Show \"system\" with collapsible search bar", action: #selector(showRegularTitleWithShyAccessory)))
        container.addArrangedSubview(createButton(title: "Show \"primary\" with fixed search bar", action: #selector(showRegularTitleWithFixedAccessory)))

        addTitle(text: "Size Customization")
        container.addArrangedSubview(createButton(title: "Show with expanded avatar, contracted title", action: #selector(showLargeTitleWithCustomizedElementSizes)))

        addTitle(text: "Custom Navigation Bar Color")
        container.addArrangedSubview(createButton(title: "Show with gradient navigation bar color", action: #selector(showLargeTitleWithCustomizedColor)))
    }

    @objc func showLargeTitle() {
        presentController(withLargeTitle: true)
    }

    @objc func showLargeTitleWithShyAccessory() {
        presentController(withLargeTitle: true, accessoryView: createAccessoryView(), contractNavigationBarOnScroll: true)
    }

    @objc func showLargeTitleWithFixedAccessory() {
        presentController(withLargeTitle: true, accessoryView: createAccessoryView(), contractNavigationBarOnScroll: false)
    }

    @objc func showLargeTitleWithSystemStyle() {
        presentController(withLargeTitle: true, style: .system)
    }

    @objc func showLargeTitleWithSystemStyleAndNoShadow() {
        presentController(withLargeTitle: true, style: .system, contractNavigationBarOnScroll: false, showShadow: false)
    }

    @objc func showLargeTitleWithSystemStyleAndShyAccessory() {
        presentController(withLargeTitle: true, style: .system, accessoryView: createAccessoryView(with: .darkContent), contractNavigationBarOnScroll: true)
    }

    @objc func showLargeTitleWithSystemStyleAndFixedAccessory() {
        presentController(withLargeTitle: true, style: .system, accessoryView: createAccessoryView(with: .darkContent), contractNavigationBarOnScroll: false)
    }

    @objc func showRegularTitleWithShyAccessory() {
        presentController(withLargeTitle: false, style: .system, accessoryView: createAccessoryView(with: .darkContent), contractNavigationBarOnScroll: true)
    }

    @objc func showRegularTitleWithFixedAccessory() {
        presentController(withLargeTitle: false, accessoryView: createAccessoryView(), contractNavigationBarOnScroll: false)
    }

    @objc func showLargeTitleWithCustomizedElementSizes() {
        let controller = presentController(withLargeTitle: true, accessoryView: createAccessoryView())
        controller.msNavigationBar.avatarSize = .expanded
        controller.msNavigationBar.titleSize = .contracted
    }

    @objc func showLargeTitleWithCustomizedColor() {
        presentController(withLargeTitle: true, style: .custom, accessoryView: createAccessoryView())
    }

    @objc func showLargeTitleWithoutAvatar() {
        presentController(withLargeTitle: true, style: .primary, accessoryView: createAccessoryView(), showAvatar: false)
    }

    @discardableResult
    private func presentController(withLargeTitle useLargeTitle: Bool, style: MSNavigationBar.Style = .primary, accessoryView: UIView? = nil, contractNavigationBarOnScroll: Bool = true, showShadow: Bool = true, showAvatar: Bool = true) -> MSNavigationController {
        let content = RootViewController()
        content.navigationItem.usesLargeTitle = useLargeTitle
        content.navigationItem.navigationBarStyle = style
        content.navigationItem.navigationBarShadow = showShadow ? .automatic : .alwaysHidden
        content.navigationItem.accessoryView = accessoryView
        content.navigationItem.contentScrollView = contractNavigationBarOnScroll ? content.tableView : nil
        content.showsTabs = !showShadow
        if style == .custom {
            content.navigationItem.navigationBarColor = CustomGradient.getCustomBackgroundColor(width: view.frame.width)
        }

        let controller = MSNavigationController(rootViewController: content)
        if showAvatar {
            controller.msNavigationBar.avatar = MSPersonaData(name: "Kat Larrson", avatarImage: UIImage(named: "avatar_kat_larsson"))
            controller.msNavigationBar.onAvatarTapped = handleAvatarTapped
        } else {
            content.allowsCellSelection = true
        }

        controller.modalPresentationStyle = .fullScreen
        if useLargeTitle {
            let leadingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
            leadingEdgeGesture.edges = view.effectiveUserInterfaceLayoutDirection == .leftToRight ? .left : .right
            leadingEdgeGesture.delegate = self
            controller.view.addGestureRecognizer(leadingEdgeGesture)
        }

        present(controller, animated: false)

        return controller
    }

    private func createAccessoryView(with style: MSSearchBar.Style = .lightContent) -> UIView {
        let searchBar = MSSearchBar()
        searchBar.style = style
        searchBar.placeholderText = "Search"
        return searchBar
    }

    private func presentSideDrawer(presentingGesture: UIPanGestureRecognizer? = nil) {
        let meControl = MSLabel(style: .title2, colorStyle: .regular)
        meControl.text = "Me Control goes here"
        meControl.textAlignment = .center

        let controller = MSDrawerController(sourceView: view, sourceRect: .zero, presentationDirection: .fromLeading)
        controller.contentView = meControl
        controller.preferredContentSize.width = 360
        controller.presentingGesture = presentingGesture
        controller.resizingBehavior = .dismiss
        presentedViewController?.present(controller, animated: true)
    }

    private func handleAvatarTapped() {
        presentSideDrawer()
    }

    @objc private func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .began {
            presentSideDrawer(presentingGesture: gesture)
        }
    }
}

// MARK: - MSNavigationControllerDemoController: UIGestureRecognizerDelegate

extension MSNavigationControllerDemoController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Only show side drawer for the root view controller
        if let controller = presentedViewController as? UINavigationController,
            gestureRecognizer is UIScreenEdgePanGestureRecognizer && gestureRecognizer.view == controller.view && controller.topViewController != controller.viewControllers.first {
            return false
        }
        return true
    }
}

// MARK: - RootViewController

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var container: UIStackView { return view as! UIStackView }
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        return tableView
    }()

    var allowsCellSelection: Bool = false {
        didSet {
            updateRightBarButtonItems()
        }
    }

    var showsTabs: Bool = false {
        didSet {
            if showsTabs != oldValue {
                segmentedControl = showsTabs ? MSSegmentedControl(items: ["Unread", "All"]) : nil
            }
        }
    }

    private var isInSelectionMode: Bool = false {
        didSet {
            tableView.allowsMultipleSelection = isInSelectionMode

            for indexPath in tableView.indexPathsForVisibleRows ?? [] {
                if let cell = tableView.cellForRow(at: indexPath) as? MSTableViewCell {
                    cell.setIsInSelectionMode(isInSelectionMode, animated: true)
                }
            }

            updateNavigationTitle()
            updateLeftBarButtonItems()
            updateRightBarButtonItems()
        }
    }

    private var navigationBarFrameObservation: NSKeyValueObservation?

    private var segmentedControl: MSSegmentedControl? {
        didSet {
            oldValue?.removeFromSuperview()
            if let segmentedControl = segmentedControl {
                container.insertArrangedSubview(segmentedControl, at: 0)
            }
        }
    }

    override func loadView() {
        let container = UIStackView()
        container.axis = .vertical
        view = container
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        container.addArrangedSubview(tableView)
        updateNavigationTitle()
        updateLeftBarButtonItems()
        updateRightBarButtonItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        navigationBarFrameObservation = navigationController?.navigationBar.observe(\.frame, options: [.old, .new]) { [unowned self] navigationBar, change in
            if change.newValue?.width != change.oldValue?.width && self.navigationItem.navigationBarStyle == .custom {
                self.navigationItem.navigationBarColor = CustomGradient.getCustomBackgroundColor(width: navigationBar.frame.width)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier, for: indexPath) as! MSTableViewCell
        cell.setup(title: "Cell #\(1 + indexPath.row)", accessoryType: .disclosureIndicator)
        cell.isInSelectionMode = isInSelectionMode
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        } else {
            let controller = ChildViewController()
            if navigationItem.accessoryView == nil {
                controller.navigationItem.navigationBarStyle = .system
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        }
    }

    private func updateNavigationTitle() {
        if isInSelectionMode {
            let selectedCount = tableView.indexPathsForSelectedRows?.count ?? 0
            navigationItem.title = selectedCount == 1 ? "1 item selected" : "\(selectedCount) items selected"
        } else {
            navigationItem.title = navigationItem.usesLargeTitle ? "Large Title" : "Regular Title"
        }
    }

    private func updateLeftBarButtonItems() {
        if isInSelectionMode {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Dismiss_28"), landscapeImagePhone: UIImage(named: "Dismiss_24"), style: .plain, target: self, action: #selector(dismissSelectionMode))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }

    private func updateRightBarButtonItems() {
        if isInSelectionMode {
            navigationItem.rightBarButtonItems = nil
        } else {
            var items = [UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissSelf))]
            if allowsCellSelection {
                items.append(UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(showSelectionMode)))
            } else {
                let modalViewItem = UIBarButtonItem(image: UIImage(named: "3-day-view-28x28"), landscapeImagePhone: UIImage(named: "3-day-view-24x24"), style: .plain, target: self, action: #selector(showModalView))
                modalViewItem.accessibilityLabel = "Modal View"
                items.append(modalViewItem)
            }
            navigationItem.rightBarButtonItems = items
        }
    }

    @objc private func dismissSelf() {
        dismiss(animated: false)
    }

    @objc private func showModalView() {
        let modalNavigationController = UINavigationController(rootViewController: ModalViewController(style: .grouped))
        present(modalNavigationController, animated: true)
    }

    @objc private func showSelectionMode() {
        isInSelectionMode = true
    }

    @objc private func dismissSelectionMode() {
        isInSelectionMode = false
    }

}

// MARK: - ChildViewController

class ChildViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        navigationItem.title = "Regular Title"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier, for: indexPath) as! MSTableViewCell
        cell.setup(title: "Child Cell #\(1 + indexPath.row)")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ModalViewController

class ModalViewController: UITableViewController {
    private var isGrouped: Bool = false {
        didSet {
            updateTableView()
        }
    }

    private var styleButtonTitle: String {
        return isGrouped ? "Switch to Plain style" : "Switch to Grouped style"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        tableView.register(MSTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: MSTableViewHeaderFooterView.identifier)
        updateTableView()

        navigationItem.title = "Modal View"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(dismissSelf))

        navigationController?.isToolbarHidden = false
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: styleButtonTitle, style: .plain, target: self, action: #selector(styleBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier, for: indexPath) as! MSTableViewCell
        cell.setup(title: "Child Cell #\(1 + indexPath.row)")
        cell.backgroundColor = isGrouped ? MSColors.Table.Cell.backgroundGrouped : MSColors.Table.Cell.background
        cell.topSeparatorType = isGrouped && indexPath.row == 0 ? .full : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MSTableViewHeaderFooterView.identifier) as! MSTableViewHeaderFooterView
        header.setup(style: .header, title: "Section Header")
        return header
    }

    @objc private func styleBarButtonTapped(sender: UIBarButtonItem) {
        isGrouped = !isGrouped
        sender.title = styleButtonTitle
    }

    private func updateTableView() {
        tableView.backgroundColor = isGrouped ? MSColors.Table.backgroundGrouped : MSColors.Table.background
        tableView.reloadData()
    }
}

// MARK: - Gradient Color

class CustomGradient {
    class func getCustomBackgroundColor(width: CGFloat) -> UIColor {
        let startColor: UIColor = #colorLiteral(red: 0.8156862745, green: 0.2156862745, blue: 0.3529411765, alpha: 1)
        let midColor: UIColor = #colorLiteral(red: 0.8470588235, green: 0.231372549, blue: 0.003921568627, alpha: 1)
        let endColor: UIColor = #colorLiteral(red: 0.8470588235, green: 0.231372549, blue: 0.003921568627, alpha: 1)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: 1.0)
        gradientLayer.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(light: image != nil ? UIColor(patternImage: image!) : endColor, dark: MSColors.Navigation.Primary.background)
    }
}
