//
//  ProfileViewController.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {

    let PROPERTY_CELL_IDENTIFIER = "cell"

    var profileModelController: ProfileModelController

    var propertiesTableView: UITableView!

    // Events

    required init(_ mc: ProfileModelController) {
        profileModelController = mc
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("Error: NSCoder is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileModelController.loadProfileProperties()

        showView()
        showNavigationBar()
        showProfilePropertiesTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateProfilePropertiesTable()
    }

    @objc func editNavButtonPressed() {
        showEditProfileScreen()
    }

    // Actions

    func showView() {
        view.backgroundColor = .white
    }

    func showEditProfileScreen() {
        let editProfileModelController = EditProfileModelController(profileModelController.profile.copy(), delegate: profileModelController)
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
        propertiesTableView.register(PropertyViewCell.self, forCellReuseIdentifier: PROPERTY_CELL_IDENTIFIER)
        view.addSubview(propertiesTableView)

        propertiesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        propertiesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        propertiesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        propertiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func updateProfilePropertiesTable() {
        propertiesTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileModelController.getPropertiesCount()
    }

    // Events

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PROPERTY_CELL_IDENTIFIER) as! PropertyViewCell

        showPropertyCell(cell: cell, indexPath: indexPath)

        return cell
    }

    // Actions

    func showPropertyCell(cell: PropertyViewCell, indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.rowIndex = indexPath.row
        cell.isEditableProperty = false

        cell.delegate = self

        let propertyData = profileModelController.makeDataForPropertyCell(index: indexPath.row)
        cell.updateCell(values: propertyData)
    }
}

// MARK: - PropertyViewCellDelegate
extension ProfileViewController: PropertyViewCellDelegate {

    // Events

    func propertyTextChanged(_ cell: PropertyViewCell, text: String, rowIndex: Int) {
        // do nothing
    }

    // Actions

    func updatePropertyCellHeight(_ cell: PropertyViewCell) {
        propertiesTableView.beginUpdates()
        propertiesTableView.endUpdates()
    }

}




