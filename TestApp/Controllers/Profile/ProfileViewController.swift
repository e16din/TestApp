//
//  ProfileViewController.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {

    let PROFILE_PROPERTY_CELL = "PROFILE_PROPERTY_CELL"

    var profileModelController: ProfileModelController

    var propertiesTableView: UITableView!

    // MARK: - Events

    required init(_ modelController: ProfileModelController) {
        profileModelController = modelController
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("Error: NSCoder is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        showView()
        showNavigationBar()
        showProfilePropertiesTable()

        profileModelController.loadProfileAsync {
            self.profileModelController.isProfileLoaded = true
            self.reloadProfilePropertiesTable()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if profileModelController.isProfileLoaded {
            reloadProfilePropertiesTable()
        }
    }

    @objc func editNavButtonPressed() {
        showEditProfileScreen()
    }

    // MARK: - Actions

    func showView() {
        view.backgroundColor = .white
    }

    func showEditProfileScreen() {
        let editProfileModelController = EditProfileModelController(profileModelController.profile, delegate: profileModelController)
        let editProfileViewController = EditProfileViewController(editProfileModelController)
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    func showNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = "Просмотр"

            let editItem = UIBarButtonItem(title: "Редактировать", style: .plain, target: self,
                action: #selector(editNavButtonPressed))
            navigationBar.topItem?.rightBarButtonItem = editItem
        }
    }

    func showProfilePropertiesTable() {
        propertiesTableView = UITableView()
        propertiesTableView.delegate = self
        propertiesTableView.dataSource = self
        propertiesTableView.translatesAutoresizingMaskIntoConstraints = false
        propertiesTableView.register(PropertyViewCell.self, forCellReuseIdentifier: PROFILE_PROPERTY_CELL)
        view.addSubview(propertiesTableView)

        propertiesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        propertiesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        propertiesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        propertiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func reloadProfilePropertiesTable() {
        propertiesTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileModelController.getPropertiesCount()
    }

    // MARK: - Events

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PROFILE_PROPERTY_CELL) as! PropertyViewCell

        showPropertyCell(cell: cell, indexPath: indexPath)

        return cell
    }

    // MARK: - Actions

    func showPropertyCell(cell: PropertyViewCell, indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.rowIndex = indexPath.row
        cell.isEditableProperty = false

        cell.delegate = self

        let propertyData = profileModelController.getPropertyCellData(indexPath.row)
        cell.updateCell(propertyData)
    }
}

// MARK: - PropertyViewCellDelegate
extension ProfileViewController: PropertyViewCellDelegate {

    // MARK: - Events

    func propertyTextChanged(_ cell: PropertyViewCell, text: String, rowIndex: Int) {
        // do nothing
    }

    // MARK: - Actions

    func updatePropertyCellHeight(_ cell: PropertyViewCell) {
        propertiesTableView.beginUpdates()
        propertiesTableView.endUpdates()
    }

}




