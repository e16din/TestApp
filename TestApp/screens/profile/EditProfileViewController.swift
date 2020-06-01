//
//  EditProfileScreen.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

class EditProfileScreen {
    var profileData = ProfileData()
}

class EditProfileViewController: UIViewController {

    var screen = EditProfileScreen()

    var vNavigationBar: UINavigationBar!

    // Events

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBar()
        showProfileView()
    }

    @objc func onSaveClick() {
        let defaults = UserDefaults.standard

        for property in screen.profileData.properties {
            defaults.set(property.value, forKey: property.type.toString())
        }
    }

    // Actions

    func showNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(onSaveClick))
        navigationItem.title = "Редактирование"
    }

    func showProfileView() {
        let vProfileContainer = ProfileView(frame: view.frame)
        vProfileContainer.data = screen.profileData
        vProfileContainer.data.editModeEnabled = true

        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = (self.navigationController?.navigationBar.intrinsicContentSize.height)!
        vProfileContainer.layoutMargins.top = statusBarHeight + navBarHeight
        view.addSubview(vProfileContainer)
    }
}


