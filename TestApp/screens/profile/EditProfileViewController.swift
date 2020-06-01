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

class EditProfileViewController: UIViewController, ClickListenerProtocol {

    var screen = EditProfileScreen()

    var vNavigationBar: UINavigationBar!

    // Events

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBar()
        showProfileView()
    }

    @objc func onActionSaveClick() {
        saveProfileProperties()
        showValidationFailedAlert()
    }

    func onBirthdayPropertyClick() {
        print("1")
    }

    func onSexPropertyClick() {
        print("2")
    }

    // Actions

    func showValidationFailedAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Все поля, за исключением отчества являются обязательными", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style { //todo
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")


            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func saveProfileProperties() {
        let defaults = UserDefaults.standard

        for property in screen.profileData.properties {
            defaults.set(property.value, forKey: property.type.toString())
        }
    }

    func showNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(onActionSaveClick))
        navigationItem.title = "Редактирование"
    }

    func showProfileView() {
        let vProfileContainer = ProfileView(frame: view.frame)
        vProfileContainer.data = screen.profileData
        vProfileContainer.data.editModeEnabled = true
        vProfileContainer.clickListenerDelegate = self

        view.addSubview(vProfileContainer)
    }
}


