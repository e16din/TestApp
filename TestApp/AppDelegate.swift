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

    private func showProfileScreen() {
        let profile = makeEmptyProfile()
        let profileModelController = ProfileModelController(profile)
        let profileViewController = ProfileViewController(profileModelController)
        window?.rootViewController = UINavigationController(rootViewController: profileViewController)
        window?.makeKeyAndVisible()
    }

    private func makeEmptyProfile() -> Profile {
        Profile([
            Profile.Property(name: .Name, value: ""),
            Profile.Property(name: .Surname, value: ""),
            Profile.Property(name: .Patronymic, value: ""),
            Profile.Property(name: .Birthday, value: ""),
            Profile.Property(name: .Sex, value: ""),
        ])
    }
}