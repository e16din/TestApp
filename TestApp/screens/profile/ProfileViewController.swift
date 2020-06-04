//
//  ProfileViewController.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let profileFruit = ProfileFruit()

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
        fruits.profile = profileFruit

        let defaults = UserDefaults.standard

        for (index, property) in fruits.profile.properties.enumerated() {
            if let value = defaults.string(forKey: property.type.toString()) {
                fruits.profile.properties[index].value = value
            }
        }
    }

    func showEditProfileScreen() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.oldValues = fruits.profile.properties.map({ it in
            it.copy()
        })
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    func showNavigationBar() {
        if let vNavigationBar = navigationController?.navigationBar {
            vNavigationBar.topItem?.title = "Просмотр"

            let editItem = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(onActionEditClick))
            vNavigationBar.topItem?.rightBarButtonItem = editItem
        }
    }

    func showProfileView() {
        vProfileContainer = ProfileView(frame: UIScreen.main.bounds)
        vProfileContainer.editModeEnabled = false
        view.addSubview(vProfileContainer)
    }

    func updateProfileView() {
        vProfileContainer.removeFromSuperview()
        showProfileView()
    }
}


