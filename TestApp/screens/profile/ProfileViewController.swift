//
//  ProfileViewController.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

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

        for (index, property) in vProfileContainer.data.properties.enumerated() {
            switch property.type {
            case .Birthday:
                let birthdayValue: String? = defaults.string(forKey: property.type.toString())
                vProfileContainer.data.properties[index].value = {
                    let value: Any? = defaults.value(forKey: property.type.toString())
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    return dateFormatter.date(from: birthdayValue ?? ProfileFruit.DEFAULT_BIRTHDAY)
                }()

            default:
                let value: Any? = defaults.value(forKey: property.type.toString())
                vProfileContainer.data.properties[index].value = value
            }
        }
    }

    func showEditProfileScreen() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.oldValues = vProfileContainer.data.properties.map({ it in
            it.value
        })
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        vProfileContainer.data = appDelegate.profileFruit
        vProfileContainer.data.editModeEnabled = false

        view.addSubview(vProfileContainer)
    }

    func updateProfileView() {
        vProfileContainer.removeFromSuperview()
        showProfileView()
    }
}


