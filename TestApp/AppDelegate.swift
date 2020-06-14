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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        showProfileScreen()

        return true
    }

    func showProfileScreen() {
        let profile = Profile()
        let profileModelController = ProfileModelController(profile)
        let profileViewController = ProfileViewController(profileModelController)
        window?.rootViewController = UINavigationController(rootViewController: profileViewController)
        window?.makeKeyAndVisible()
    }

}