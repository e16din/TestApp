//
//  EditProfileScreen.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController {

    let PROPERTY_CELL_IDENTIFIER = "cell"

    var editProfileModelController: EditProfileModelController

    var navigationBar: UINavigationBar!
    var propertiesTableView: UITableView!

    var birthdayPicker: DatePickerView!
    var sexPicker: ItemPickerView!

    var exitAlert: UIAlertController!

    // Events

    required init(_ mc: EditProfileModelController) {
        editProfileModelController = mc
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
    }

    @objc func saveNavButtonPressed() {
        let isValid = editProfileModelController.areRequiredPropertiesFilled()
        if !isValid {
            showValidationFailedAlert()

        } else {
            editProfileModelController.saveProfileProperties()
        }
    }

    @objc func backNavButtonPressed() {
        let hasChanges = editProfileModelController.isProfileChanged()
        if hasChanges {
            showExitAlert()
            return
        }

        hideEditProfileScreen()
    }

    // Actions

    func showView() {
        view.backgroundColor = .white
    }

    func showNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"

        navigationController?.navigationBar.topItem?.hidesBackButton// = backButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self,
            action: #selector(backNavButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self,
            action: #selector(saveNavButtonPressed))
        navigationItem.title = "Редактирование"
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

    func showValidationFailedAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Все поля, за исключением отчества являются обязательными", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showExitAlert() {
        exitAlert = UIAlertController(title: "Внимание!",
            message: "Данные были изменены. Вы желаете сохранить изменения, в противном случае внесенные правки будут\nотменены.",
            preferredStyle: UIAlertController.Style.alert)

        exitAlert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { (action: UIAlertAction?) in
            let isValid = self.editProfileModelController.areRequiredPropertiesFilled()
            if !isValid {
                self.showValidationFailedAlert()

            } else {
                self.editProfileModelController.saveProfileProperties()
                self.hideEditProfileScreen()
            }
        }))

        exitAlert.addAction(UIAlertAction(title: "Пропустить", style: .cancel, handler: { (action: UIAlertAction?) in
            self.hideEditProfileScreen()
        }))

        present(exitAlert, animated: true, completion: nil)
    }

    func hideEditProfileScreen() {
        exitAlert?.dismiss(animated: false)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension EditProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        editProfileModelController.getPropertiesCount()
    }

    // Events

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PROPERTY_CELL_IDENTIFIER) as! PropertyViewCell

        showPropertyCell(cell: cell, indexPath: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let propertyName = editProfileModelController.profile.properties[indexPath.row].name

        switch propertyName {
        case .Birthday:
            showBirthdayPicker()
        case .Sex:
            showSexPicker()
        case .Name, .Surname, .Patronymic:
            // Set focus to any PropertyViewCell.UITextView
            break
        }
    }

    // Actions

    func showPropertyCell(cell: PropertyViewCell, indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.rowIndex = indexPath.row
        cell.isEditableProperty = true

        cell.delegate = self

        let propertyData = editProfileModelController.makeDataForPropertyCell(index: indexPath.row)
        cell.updateCell(values: propertyData)
    }

    func reloadPropertyCell(_ name: Profile.Property.Name) {
        let propertyIndex = editProfileModelController.getPropertyIndex(name)
        propertiesTableView.reloadRows(at: [IndexPath(item: propertyIndex, section: 0)], with: .none)
    }

    func showBirthdayPicker() {
        if birthdayPicker != nil && birthdayPicker.isDescendant(of: view) {
            print("The vBirthdayPicker is always shown")
            return
        }

        birthdayPicker = DatePickerView({
            let dateValue = editProfileModelController.getPropertyValue(.Birthday)
            let hasSelectedDate = !dateValue.isEmpty
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"

            return hasSelectedDate
                ? dateFormatter.date(from: dateValue)!
                : Date()
        }())
        birthdayPicker.delegate = self

        view.addSubview(birthdayPicker)

        birthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        birthdayPicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        birthdayPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        birthdayPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }

    func showSexPicker() {
        if sexPicker != nil && sexPicker.isDescendant(of: view) {
            print("The sexPicker is always shown")
            return
        }

        let sexValue = editProfileModelController.getPropertyValue(.Sex)
        let sexTypes = Profile.SexTypes().sexTypes
        sexPicker = ItemPickerView(sexTypes, selectedRow: Int(sexValue) ?? 0)
        sexPicker.delegate = self

        view.addSubview(sexPicker)

        sexPicker.translatesAutoresizingMaskIntoConstraints = false
        sexPicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sexPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sexPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sexPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
}

// MARK: - PropertyViewCellDelegate
extension EditProfileViewController: PropertyViewCellDelegate {

    // Events

    func propertyTextChanged(_ cell: PropertyViewCell, text: String, rowIndex: Int) {
        editProfileModelController.updateProperty(rowIndex, value: text)
    }

    // Actions

    func updatePropertyCellHeight(_ cell: PropertyViewCell) {
        propertiesTableView.beginUpdates()
        propertiesTableView.endUpdates()
    }

}

// MARK: - Pick Birthday
extension EditProfileViewController: DatePickerDelegate {

    // Events

    func dateChanged(_ view: DatePickerView, date: Date) {
        let dateString = date.toString(dateFormat: "dd.MM.yyyy")
        editProfileModelController.updateProperty(.Birthday, value: dateString)
        reloadPropertyCell(.Birthday)
    }

    func dateSelected(_ view: DatePickerView, selectedDate: Date) {
        birthdayPicker.removeFromSuperview()
        let dateString = selectedDate.toString(dateFormat: "dd.MM.yyyy")
        editProfileModelController.updateProperty(.Birthday, value: dateString)
        reloadPropertyCell(.Birthday)
    }

    // Actions

    func cancelDatePicker() {
        birthdayPicker.removeFromSuperview()
        let originBirthdayDate = editProfileModelController.getOriginPropertyValue(.Birthday)
        editProfileModelController.updateProperty(.Birthday, value: originBirthdayDate)
        reloadPropertyCell(.Birthday)
    }
}

// MARK: - Pick Sex
extension EditProfileViewController: ItemPickerDelegate {

    // Events

    func itemChanged(_ view: ItemPickerView, index: Int) {
        editProfileModelController.updateProperty(.Sex, value: String(index))
        reloadPropertyCell(.Sex)
    }

    func itemSelected(_ view: ItemPickerView, index: Int) {
        sexPicker.removeFromSuperview()
        editProfileModelController.updateProperty(.Sex, value: String(index))
        reloadPropertyCell(.Sex)
    }

    // Actions

    func cancelItemPicker() {
        sexPicker.removeFromSuperview()
        let originSexType = editProfileModelController.getOriginPropertyValue(.Sex)
        editProfileModelController.updateProperty(.Sex, value: originSexType)
        reloadPropertyCell(.Sex)
    }
}