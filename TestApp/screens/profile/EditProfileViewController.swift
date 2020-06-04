//
//  EditProfileScreen.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController,
    ProfileViewProtocol,
    NavigationViewControllerDelegate {

    var oldValues: [ProfileFruit.Property]!

    var vNavigationBar: UINavigationBar!
    var vProfileContainer: ProfileView!
    var vBirthdayPicker: DatePickerView!
    var vSexPicker: ItemPickerView!
    var vExitAlert: UIAlertController!

    func getPropertyIndex(propertyType: ProfileFruit.Property.PropertyType) -> Int {
        fruits.profile.properties.firstIndex(where: { $0.type == propertyType })!
    }

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
        showBirthdayPicker()
    }

    func onSexPropertyClick() {
        showSexPicker()
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

        for property in fruits.profile.properties {
            defaults.set(property.value, forKey: property.type.toString())
        }
    }

    func showNavigationBar() {
        let vBackButton = UIBarButtonItem()
        vBackButton.title = "Назад"
        navigationController?.navigationBar.topItem?.backBarButtonItem = vBackButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(onActionSaveClick))
        navigationItem.title = "Редактирование"

        (self.navigationController as? NavigationViewController)?.backDelegate = self

    }

    func showProfileView() {
        vProfileContainer = ProfileView(frame: view.frame)

        vProfileContainer.editModeEnabled = true
        vProfileContainer.delegate = self

        view.addSubview(vProfileContainer)
    }

    func updatePropertyValue(value: String, propertyType: ProfileFruit.Property.PropertyType) {
        let propertyIndex = getPropertyIndex(propertyType: propertyType)
        fruits.profile.properties[propertyIndex].value = value
        vProfileContainer.updateProperty(index: propertyIndex)
    }
}

// Pick Birthday
extension EditProfileViewController: DatePickerDelegate {

    // Events

    func onDatePickerValueChanged(selectedDate: Date) {
        let dateString = selectedDate.toString(dateFormat: "dd.MM.yyyy")
        updatePropertyValue(value: dateString, propertyType: .Birthday)
    }

    func onDatePickerValueSelected(selectedDate: Date) {
        hideDatePicker()
        let dateString = selectedDate.toString(dateFormat: "dd.MM.yyyy")
        updatePropertyValue(value: dateString, propertyType: .Birthday)
    }

    func onDatePickerCancel() {
        hideDatePicker()

        let birthdayPropertyIndex = getPropertyIndex(propertyType: .Birthday)
        let oldBirthdayDate = oldValues[birthdayPropertyIndex].value
        updatePropertyValue(value: oldBirthdayDate, propertyType: .Birthday)
    }

    func onTouchOutsideDatePicker() {
        onDatePickerCancel()
    }

    // Actions

    func showBirthdayPicker() {
        if vBirthdayPicker != nil && vBirthdayPicker.isDescendant(of: view) {
            print("The vBirthdayPicker is always shown")
            return
        }

        vBirthdayPicker = DatePickerView()
        vBirthdayPicker.datePickerDelegate = self

        let birthdayPropertyIndex = getPropertyIndex(propertyType: .Birthday)
        let dateValue = fruits.profile.properties[birthdayPropertyIndex].value

        vBirthdayPicker.initPicker(date: {
            let hasSelectedDate = dateValue != ProfileFruit.DEFAULT_BIRTHDAY
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"

            return hasSelectedDate
                ? dateFormatter.date(from: dateValue)!
                : Date()
        }())

        view.addSubview(vBirthdayPicker)

        vBirthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        vBirthdayPicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vBirthdayPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vBirthdayPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vBirthdayPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }

    func hideDatePicker() {
        vBirthdayPicker.removeFromSuperview()
    }
}

// Pick Sex
extension EditProfileViewController: ItemPickerDelegate {

    // Events

    func onItemPickerValueChanged(selectedItemPosition: Int) {
        updatePropertyValue(value: String(selectedItemPosition), propertyType: .Sex)
    }

    func onItemPickerValueSelected(selectedItemPosition: Int) {
        hideItemPicker()
        updatePropertyValue(value: String(selectedItemPosition), propertyType: .Sex)
    }

    func onItemPickerCancel() {
        hideItemPicker()

        let sexPropertyIndex = getPropertyIndex(propertyType: .Sex)
        let oldSexType = oldValues[sexPropertyIndex].value
        updatePropertyValue(value: oldSexType, propertyType: .Sex)
    }

    func onTouchOutsideItemPicker() {
        onItemPickerCancel()
    }

    // Actions

    func showSexPicker() {
        if vSexPicker != nil && vSexPicker.isDescendant(of: view) {
            print("The vSexPicker is always shown")
            return
        }

        vSexPicker = ItemPickerView()
        vSexPicker.itemPickerDelegate = self

        let sexValue = fruits.profile.properties[getPropertyIndex(propertyType: .Sex)].value
        vSexPicker.initPicker(items: ProfileFruit.SEX_TYPES, selectedRow: Int(sexValue)!)

        view.addSubview(vSexPicker)

        vSexPicker.translatesAutoresizingMaskIntoConstraints = false
        vSexPicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vSexPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vSexPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vSexPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }

    func hideItemPicker() {
        vSexPicker.removeFromSuperview()
    }
}

// Handle Back Button
extension EditProfileViewController {

    // Events

    func onBackButtonPressed() -> Bool {

        var hasChanges = false

        for (index, property) in fruits.profile.properties.enumerated() {
            hasChanges = property.value != oldValues[index].value
            if (hasChanges) {
                break
            }
        }

        if hasChanges {
            showExitAlert()
            return false
        }

        return true
    }

    var onExitAlertActionSave: (UIAlertAction!) -> () {
        get {
            { (action: UIAlertAction!) in
                self.saveProfileProperties()
                self.hideEditProfileScreen()
            }
        }
    }

    var onExitAlertActionCancel: (UIAlertAction!) -> () {
        get {
            { (action: UIAlertAction!) in
                self.fruits.profile.properties = self.oldValues
                self.hideEditProfileScreen()
            }
        }
    }

    // Actions

    func showExitAlert() {
        vExitAlert = UIAlertController(title: "Внимание!",
            message: "Данные были изменены. Вы желаете сохранить изменения, в противном случае внесенные правки будут\nотменены.",
            preferredStyle: UIAlertController.Style.alert)

        vExitAlert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: onExitAlertActionSave))
        vExitAlert.addAction(UIAlertAction(title: "Пропустить", style: .cancel, handler: onExitAlertActionCancel))

        present(vExitAlert, animated: true, completion: nil)
    }

    func hideEditProfileScreen() {
        (navigationController as! NavigationViewController).backDelegate = nil
        vExitAlert.dismiss(animated: false)
        navigationController?.popViewController(animated: true)
    }
}
