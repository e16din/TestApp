//
//  EditProfileScreen.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController {

    let editProfilePropertyCellId = "EDIT_PROFILE_PROPERTY_CELL"

    var editProfileModelController: EditProfileModelController

    var navigationBar: UINavigationBar!
    var propertiesTableView: UITableView!

    var birthdayPicker: DatePickerView!
    var sexPicker: ItemPickerView!

    var exitAlert: UIAlertController!

    // MARK: - Events

    required init(_ modelController: EditProfileModelController) {
        editProfileModelController = modelController
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
            editProfileModelController.saveProfileAsync(nil)
        }
    }

    @objc func backNavButtonPressed() {
        let hasChanges = editProfileModelController.isProfileChanged()
        if hasChanges {
            showExitAlert()

        } else {
            hideEditProfileScreen()
        }
    }

    // MARK: - Actions

    func showView() {
        view.backgroundColor = .white
    }

    func showNavigationBar() {
        navigationController?.navigationBar.topItem?.hidesBackButton

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
        propertiesTableView.register(PropertyViewCell.self, forCellReuseIdentifier: editProfilePropertyCellId)
        view.addSubview(propertiesTableView)

        propertiesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        propertiesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        propertiesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        propertiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func showValidationFailedAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Все поля, за исключением отчества являются обязательными",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showExitAlert() {
        exitAlert = UIAlertController(title: "Внимание!",
            message: "Данные были изменены. Вы желаете сохранить изменения, в противном случае внесенные правки будут\nотменены.",
            preferredStyle: .alert)

        exitAlert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { (action: UIAlertAction?) in
            let isValid = self.editProfileModelController.areRequiredPropertiesFilled()
            if !isValid {
                self.showValidationFailedAlert()

            } else {
                self.editProfileModelController.saveProfileAsync {
                    self.hideEditProfileScreen()
                }
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

    // MARK: - Events

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: editProfilePropertyCellId) as! PropertyViewCell

        showPropertyCell(cell: cell, index: indexPath.row)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let propertyName = editProfileModelController.getPropertyType(indexPath.row)

        switch propertyName {
        case .birthday:
            showBirthdayPicker()
        case .sex:
            showSexPicker()
        case .name, .surname, .patronymic:
            // Set focus to any PropertyViewCell.UITextView
            break
        }
    }

    // MARK: - Actions

    func showPropertyCell(cell: PropertyViewCell, index: Int) {
        cell.selectionStyle = .none
        cell.rowIndex = index
        cell.isEditableProperty = true

        cell.delegate = self

        let property = editProfileModelController.getPropertyCellData(index: index)
        cell.updateCell(property)
    }

    func reloadPropertyCell(_ type: Profile.PropertyType) {
        let index = editProfileModelController.getPropertyIndex(type)
        propertiesTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
    }

    func showBirthdayPicker() {
        birthdayPicker = DatePickerView({
            let dateValue = editProfileModelController.getPropertyValue(.birthday)
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
        let sexValue = editProfileModelController.getPropertyValue(.sex)
        let sexTypes = SexTypes().sexTypes
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

// MARK: - PropertyViewCellDelegate | Change Name
extension EditProfileViewController: PropertyViewCellDelegate {

    // MARK: - Events

    func propertyTextChanged(_ cell: PropertyViewCell, text: String, rowIndex: Int) {
        editProfileModelController.updateProperty(rowIndex, value: text)
    }

    // MARK: - Actions

    func updatePropertyCellHeight(_ cell: PropertyViewCell) {
        propertiesTableView.beginUpdates()
        propertiesTableView.endUpdates()
    }

}

// MARK: - DatePickerDelegate | Pick Birthday
extension EditProfileViewController: DatePickerDelegate {

    // MARK: - Events

    func dateChanged(_ view: DatePickerView, date: Date) {
        let dateString = date.toString(dateFormat: "dd.MM.yyyy")
        editProfileModelController.updateProperty(.birthday, value: dateString)
        reloadPropertyCell(.birthday)
    }

    func dateSelected(_ view: DatePickerView, selectedDate: Date) {
        birthdayPicker.removeFromSuperview()
        let dateString = selectedDate.toString(dateFormat: "dd.MM.yyyy")
        editProfileModelController.updateProperty(.birthday, value: dateString)
        reloadPropertyCell(.birthday)
    }

    // MARK: - Actions

    func cancelDatePicker() {
        birthdayPicker.removeFromSuperview()
        editProfileModelController.resetBirthdayProperty()
        reloadPropertyCell(.birthday)
    }
}

// MARK: - ItemPickerDelegate | Pick Sex
extension EditProfileViewController: ItemPickerDelegate {

    // MARK: - Events

    func itemChanged(_ view: ItemPickerView, index: Int) {
        editProfileModelController.updateSexProperty(sexType: index)
        reloadPropertyCell(.sex)
    }

    func itemSelected(_ view: ItemPickerView, index: Int) {
        sexPicker.removeFromSuperview()
        editProfileModelController.updateSexProperty(sexType: index)
        reloadPropertyCell(.sex)
    }

    // MARK: - Actions

    func cancelItemPicker() {
        sexPicker.removeFromSuperview()
        editProfileModelController.resetSexProperty()
        reloadPropertyCell(.sex)
    }
}