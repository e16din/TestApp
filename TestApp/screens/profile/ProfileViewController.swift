//
//  ProfileViewController.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {

    var mcProfile : ProfileModelController!

    var vProfileContainer: ProfileView!

    // Events

    required init(mc: ProfileModelController) {
        mcProfile = mc
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("Error: NSCoder is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mcProfile.loadProfileProperties()

        showNavigationBar()
        showProfileView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileView()
    }

    @objc func onActionEditClick() {
        showEditProfileScreen()
    }

    // Actions

    func showEditProfileScreen() {
        let vcEditProfile = EditProfileViewController(mc: mcProfile)
        vcEditProfile.oldValues = mcProfile.properties.map({ it in
            it
        })
        navigationController?.pushViewController(vcEditProfile, animated: true)
    }

    func showNavigationBar() {
        if let vNavigationBar = navigationController?.navigationBar {
            vNavigationBar.topItem?.title = "Просмотр"

            let editItem = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(onActionEditClick))
            vNavigationBar.topItem?.rightBarButtonItem = editItem
        }
    }

    func showProfileView() {
        vProfileContainer = ProfileView(frame: UIScreen.main.bounds, mcProfile: mcProfile)
        vProfileContainer.mcProfile = mcProfile
        vProfileContainer.editModeEnabled = false
        view.addSubview(vProfileContainer)
    }

    func updateProfileView() {
        vProfileContainer.removeFromSuperview()
        showProfileView()
    }
}


