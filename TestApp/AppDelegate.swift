//
//  AppDelegate.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 18.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

class Fruits {
    weak var profile: ProfileFruit!
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let fruits = Fruits()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let profileViewController = ProfileViewController()
        let navigationController = NavigationViewController(rootViewController: profileViewController)
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
        return backDelegate?.onBackButtonPressed() ?? true
    }
}