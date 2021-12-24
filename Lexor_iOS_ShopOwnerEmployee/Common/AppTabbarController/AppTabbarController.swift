//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

protocol AppTabbarControllerDismissDelegate: AnyObject {
    func appTabbarController(_ tabbarController: AppTabbarController, didDismissVC viewcontroller: UIViewController?)
}

class AppTabbarController: UITabBarController {

    weak var appTabbarControllerDismissDelegate: AppTabbarControllerDismissDelegate?
    var internetDeferer: InternetConnectionAvailableDefererType

    deinit {
        print("Deinit \(self.classForCoder)")
    }

    init(internetDeferer: InternetConnectionAvailableDefererType) {
        self.internetDeferer = internetDeferer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorStyles()
        showContent()
    }

    func showContent() {
        let homeVC = HomeViewController()
        let homeNV = AppNavigationController(rootViewController: homeVC)
        homeNV.tabBarItem = UITabBarItem(title: "Home",
                                         image: #imageLiteral(resourceName: "ic-tabbar-home"),
                                         selectedImage: #imageLiteral(resourceName: "ic-tabbar-home"))
        let activitiesVC = ActivitiesViewController()
        let recordsNV = AppNavigationController(rootViewController: activitiesVC)
        recordsNV.tabBarItem = UITabBarItem(title: "Activity",
                                            image: #imageLiteral(resourceName: "ic-tabbar-bank"),
                                            selectedImage: #imageLiteral(resourceName: "ic-tabbar-bank"))

        let shoppingVC = SettingViewController()
        let shoppingNV = AppNavigationController(rootViewController: shoppingVC)
        shoppingNV.tabBarItem = UITabBarItem(title: "Shopping",
                                            image: #imageLiteral(resourceName: "ic-tabbar-profile"),
                                            selectedImage: #imageLiteral(resourceName: "ic-tabbar-profile"))

        let arrayViewControllers: [UIViewController] = [homeNV,
                                                        recordsNV,
                                                        shoppingNV]

        setViewControllers(arrayViewControllers, animated: true)
    }

    func setupColorStyles() {
        let barItem = UITabBarItem.appearance(whenContainedInInstancesOf: [type(of: self)])
        let font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
        let paragraphStyle = NSMutableParagraphStyle()
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.bas80,
            .paragraphStyle: paragraphStyle
        ]
        let selectedArttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.basRedPastel,
            .paragraphStyle: paragraphStyle
        ]

        let shadowSize = CGSize(width: view.frame.size.width, height: 0.5)
        let shadowImage = UIGraphicsImageRenderer(size: shadowSize).image(actions: { cxt in
            cxt.cgContext.setFillColor(UIColor.bas10.cgColor)
            cxt.cgContext.fill(CGRect.init(origin: .zero, size: shadowSize))
        })
        let titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        if #available(iOS 13, *) {
            let appearance = self.tabBar.standardAppearance.copy()
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = shadowImage
            appearance.selectionIndicatorTintColor = .bas80

            appearance.stackedLayoutAppearance.normal.iconColor = .bas80
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = titlePositionAdjustment
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedArttributes
            appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = titlePositionAdjustment

            tabBar.standardAppearance = appearance
        } else {
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = shadowImage
            barItem.setTitleTextAttributes(normalAttributes, for: .normal)
            barItem.setTitleTextAttributes(selectedArttributes, for: .selected)
            barItem.titlePositionAdjustment = titlePositionAdjustment
        }
        tabBar.barTintColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        view.backgroundColor = .basWhite

        UITabBar.appearance().tintColor = .basRedPastel
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = self.tabBar.items?.firstIndex(of: item) else { return }
        if index == self.selectedIndex, let scrollToTopable = self.viewControllers?[index] as? ContentScrollToTopable {
            scrollToTopable.scrollToTop()
        }
    }

    func dismissModalScreen(_ completionHandler: @escaping () -> Void) {
        if let presentedViewController = presentedViewController {
            dismiss(animated: true, completion: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.appTabbarControllerDismissDelegate?.appTabbarController(strongSelf, didDismissVC: presentedViewController)
                completionHandler()
            })
        } else {
            appTabbarControllerDismissDelegate?.appTabbarController(self, didDismissVC: nil)
            DispatchQueue.main.async(execute: completionHandler)
        }
    }

}

public protocol ContentScrollToTopable {
    func scrollToTop()
}
