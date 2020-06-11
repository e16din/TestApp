//
//  AppDelegate.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 18.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: NavigationViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let vcProfile = ProfileViewController(mc: ProfileModelController())

        navigationController = NavigationViewController(rootViewController: vcProfile)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

protocol NavigationViewControllerDelegate {
    func onBackButtonPressed() -> Bool
}

class NavigationViewController: UINavigationController, UINavigationBarDelegate {
    var backDelegate: NavigationViewControllerDelegate?

    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        let shouldPop = backDelegate?.onBackButtonPressed() ?? true
        return shouldPop
    }

    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        backDelegate = nil
    }
}

class IOSVersion {
    class func SYSTEM_VERSION_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
    }

    class func SYSTEM_VERSION_GREATER_THAN(version: NSString) -> Bool {
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }

    class func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }

    class func SYSTEM_VERSION_LESS_THAN(version: NSString) -> Bool {
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }

    class func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }
}