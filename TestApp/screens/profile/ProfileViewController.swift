//
//  ProfileViewController.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class ProfileScreen {
    var profileData = ProfileData()
}

class ProfileViewController: UIViewController {

    var screen = ProfileScreen()

    var vNavigationBar: UINavigationBar!
    var vProfileContainer: ProfileView!

    // Events

    override func viewDidLoad() {
        super.viewDidLoad()

        showNavigationBar()
        showProfileView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileProperties()
        updateProfileView()
    }

    @objc func onActionEditClick() {
        showEditProfileScreen()
    }

    // Actions

    func loadProfileProperties() {
        let defaults = UserDefaults.standard

        for (index, property) in screen.profileData.properties.enumerated() {
            let value: Any? = defaults.value(forKey: property.type.toString())
            screen.profileData.properties[index].value = value
        }
    }

    func showEditProfileScreen() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.screen.profileData = screen.profileData

        navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    func showNavigationBar() {
        vNavigationBar = navigationController?.navigationBar
        vNavigationBar.topItem?.title = "Просмотр"

        let editItem = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(onActionEditClick))
        vNavigationBar.topItem?.rightBarButtonItem = editItem
    }

    func showProfileView() {
        vProfileContainer = ProfileView(frame: UIScreen.main.bounds)
        vProfileContainer.data = screen.profileData

        view.addSubview(vProfileContainer)
    }

    func updateProfileView() {
        vProfileContainer.removeFromSuperview()
        showProfileView()
    }
}


